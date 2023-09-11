import 'dart:typed_data';

import 'package:bs58/bs58.dart';
import 'package:cid/src/utils.dart';
import 'package:dart_multihash/dart_multihash.dart' as dart_multihash;

import 'models.dart';
import 'multibase.dart';

/// Decodes a `cid` string.
/// It follows the official algorithm in https://github.com/multiformats/cid/blob/ef1b2002394b15b1e6c26c30545fd485f2c4c138/README.md#decoding-algorithm.
CIDInfo decodeCIDStringInformation(String input) {
  // Check if string is 46 characters long and if starts with "Qm"
  if (input.length == 46 && input.substring(0, 2) == "Qm") {
    Uint8List decodedInput = base58.decode(input);
    return decodeCIDStringInformationStep2(decodedInput, Multibase.base58btc, input);
  }

  // Otherwise, decode it according to the multibase spec
  else {
    // Getting the base of the CID and decoding taking it into account
    final String code = input[0];
    final Multibase base = getMultibaseFromCode(code);
    Uint8List decodedArray = decodeInputStringWithBase(base, input);

    // If the first decoded byte is 0x12, return an error.
    if (decodedArray.first == 0x12) {
      throw Exception("CIDv0 CIDs may not be multibase encoded and there will be no CIDv18 (0x12 = 18) to prevent ambiguity with decoded CIDv0s");
    } else {
      return decodeCIDStringInformationStep2(decodedArray, base, input);
    }
  }
}

/// Refers to the `step2` of https://github.com/multiformats/cid/blob/ef1b2002394b15b1e6c26c30545fd485f2c4c138/README.md#decoding-algorithm
/// to decode a given `cid` string.
/// Receives the [binary] multihash and the [multibase] it was encoded in.
/// Also receives the original [cidString] string to add it to the CIDInfo object.
CIDInfo decodeCIDStringInformationStep2(Uint8List binary, Multibase multibase, String cidString) {
  // If it's 34 bytes long with the leading bytes [0x12, 0x20, ...], it's a CIDv0
  if (binary.length == 34 && binary[0] == 0x12 && binary[1] == 0x20) {
    // The CID's multihash is `cid` itself. The multibase and multicodec are implicit.
    var multihashInfo = dart_multihash.Multihash.decode(binary);

    // Codec is `DagProtobuf`
    var multicodecObj = dart_multihash.MultiCodecs.list().where((element) => element.name == "dag-pb").first;

    return CIDInfo(
        multihashInfo: multihashInfo,
        multicodecCode: multicodecObj.code,
        multicodecName: multicodecObj.name,
        version: 0,
        multibase: multibase,
        cid: cidString);
  }

  // Otherwise, let N be the first varint in `binary`. This is the CID's version.
  else {
    DecodedVarInt n = decodeVarint(binary, nOffset: 0);

    // If `N == 1`, it's CIDv1
    if (n.res == 1) {
      // The multicodec is the second varint of `binary`
      DecodedVarInt multicodec = decodeVarint(binary, nOffset: 1);
      var multicodecArray = dart_multihash.MultiCodecs.list().where((element) => element.code == multicodec.res);
      if (multicodecArray.isEmpty) {
        throw Exception("The multicodec code is not supported.");
      }
      var multicodecObj = multicodecArray.first;

      // The CID's multihash is the rest of the `binary` (after second varint)
      Uint8List multihash = binary.sublist(2);
      var multihashInfo = dart_multihash.Multihash.decode(multihash);

      // Version is CIDv1
      int version = 1;

      return CIDInfo(
          multihashInfo: multihashInfo,
          multicodecCode: multicodecObj.code,
          multicodecName: multicodecObj.name,
          version: version,
          multibase: multibase,
          cid: cidString);
    }

    // If `N <= 0`, the CID is malformed.
    else if (n.res <= 0) {
      throw Exception("The CID is malformed");
    }

    // If `N > 1`, the CID version is reserved.
    else {
      throw Exception("The CID version is reserved.");
    }
  }
}
