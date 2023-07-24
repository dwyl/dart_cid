import 'dart:typed_data';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dart_cid/src/decode_cid.dart';
import 'package:dart_cid/src/multibase.dart';
import 'package:dart_multihash/dart_multihash.dart';

import 'models.dart';
import 'multihash.dart';

/// Class that contains the functions to create a `cid`.
class CID {
  /// Creates a [`cid`](https://docs.ipfs.tech/concepts/content-addressing/#what-is-a-cid) v1
  /// that is compliant with IPFS standards
  /// The returned `cid` consists of a `sha2-256` multihash, a `raw` multicodec and base encoded either 32 or 58.
  static CIDInfo createCid(String text, Multibase base) {
    // Create multihash
    MultihashInfo multihashInfo = createMultihash(text);
    Uint8List multihashBytesArray = multihashInfo.toBytes();

    // Adding suffixes to multihash
    // Currently, the suffix consists of version 1 and `raw` multicodec.
    int version = 0x01;
    int codecCode = 0x55;
    Uint8List suffixedMultihash = addSuffixToMultihash(multihashBytesArray, version, codecCode);

    var codecObj = MultiCodecs.list().where((element) => element.code == codecCode).first;

    String cidString = encodeInputMultihashWithBase(base, suffixedMultihash);

    // Creating CIDInfo object to return
    CIDInfo cidInfo = CIDInfo(
        multihashInfo: multihashInfo,
        multicodecName: codecObj.name,
        multicodecCode: codecCode,
        multibase: base.baseName,
        version: version,
        cid: cidString);

    return cidInfo;
  }

  /// Decodes a given `cid` string
  /// and returns its information.
  static CIDInfo decodeCid(String input) {
    return decodeCIDStringInformation(input);
  }
}
