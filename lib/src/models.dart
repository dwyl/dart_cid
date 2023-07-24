import 'dart:typed_data';

import 'package:dart_multihash/dart_multihash.dart';

import 'multibase.dart';
import 'multihash.dart';

/// Class that holds the information of the provided `cid`.
class CIDInfo {
  // Multihash
  MultihashInfo multihashInfo;

  // Multicodec
  final String multicodecName;
  final int multicodecCode;

  // Version
  int version;

  // Multibase
  Multibase multibase;

  // CID string
  String cid;

  CIDInfo(
      {required this.multihashInfo,
      required this.multicodecName,
      required this.multicodecCode,
      required this.multibase,
      required this.version,
      required this.cid});

  /// Converts the object to CIDv1, if possible.
  /// A new multibase can be passed as parameter to encode the CIDv1 in a new base, if wanted.
  /// By default, the new multibase is set to `base32`.
  toV1({Multibase base = Multibase.base32}) {
    switch (version) {
      case 0:
        {
          int newVersion = 1;

          // Get multihash as array of bytes
          Uint8List multihashBytesArray = multihashInfo.toBytes();

          // Adding suffixes to multihash
          // The new CID will have a suffix of version 1 and the given multicodec
          Uint8List suffixedMultihash = addSuffixToMultihash(
              multihashBytesArray, newVersion, multicodecCode);

          // New CID string
          String newCIDString =
              encodeInputMultihashWithBase(base, suffixedMultihash);

          version = newVersion;
          cid = newCIDString;
          multibase = base;

          break;
        }
      case 1:
        {
          return this;
        }
      default:
        {
          throw Exception(
              "Can not convert CID version $version to version 1. Invalid version.");
        }
    }
  }

  /*
  /// Converts object to a CIDv0.
  /// It must have specific properties so that it can be converted to CIDv0.
  /// Check https://proto.school/anatomy-of-a-cid/06 for more information.
  toV0() {
    switch (version) {
      case 0:
        {
          return this;
        }
      case 1:
        {

          // Checking if properties are valid for conversion
          MultiCodec dagPbCodec = MultiCodecs.list().where((element) => element.name == 'dag-pb').first;

          if (multicodecName != dagPbCodec.name && multicodecCode != dagPbCodec.code) {
            throw Exception('Cannot convert a non \'dag-pb\' CID to CIDv0.');
          }

          if (multihashInfo.name != 'sha2-256') {
            throw Exception('Cannot convert non \'sha2-256\' multihash CID to CIDv0.');
          }

          if (multihashInfo.size != 32) {
            throw Exception('Cannot convert non 32 byte multihash CID to CIDv0.');
          }

          if (multibase != Multibase.base58btc) {
            throw Exception('Cannot convert non \'base58btc\' multibase CID to CIDv0.');
          }

          int newVersion = 0;

          // Get multihash as array of bytes
          Uint8List multihashBytesArray = multihashInfo.toBytes();

          // Adding suffixes to multihash
          // The new CID will have a suffix of version 1 and the given multicodec
          Uint8List suffixedMultihash = addSuffixToMultihash(multihashBytesArray, newVersion, multicodecCode);

          // New CID string
          String newCIDString = encodeInputMultihashWithBase(multibase, suffixedMultihash);

          // Change properties
          version = 0;
          cid = newCIDString;

          break;
        }
      default:
        {
          throw Exception("Can not convert CID version $version to version 1. Invalid version.");
        }
    }
  }
  */
}

/// Not all multibase spec base types are supported by this library.
/// We support the `default` ones from the official repo in https://github.com/multiformats/multibase/blob/master/multibase.csv.
enum Multibase {
  /// hexadecimal
  base16(code: 'f', name: "base16"),

  /// hexadecimal
  base16upper(code: 'F', name: "base16upper"),

  /// rfc4648 case-insensitive - no padding
  base32(code: 'b', name: "base32"),

  /// rfc4648 case-insensitive - no padding
  base32upper(code: 'B', name: "base32upper"),

  /// base58 bitcoin
  base58btc(code: 'z', name: "base58btc"),

  /// rfc4648 no padding
  base64(code: 'm', name: "base64");

  /// Initialize a new multibase variant
  const Multibase({
    required final String code,
    required final String name,
  })  : baseCode = code,
        baseName = name;

  final String baseCode;
  final String baseName;
}
