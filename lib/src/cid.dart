import 'dart:typed_data';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dart_cid/src/decode_cid.dart';
import 'package:dart_cid/src/multibase.dart';
import 'package:dart_multihash/dart_multihash.dart';

import 'multihash.dart';

/// Class that contains the functions to create a `cid`.
class CID {
  /// Creates a [`cid`](https://docs.ipfs.tech/concepts/content-addressing/#what-is-a-cid) v1
  /// that is compliant with IPFS standards
  /// The returned `cid` consists of a `sha2-256` multihash, a `raw` multicodec and base encoded either 32 or 58.
  static CIDInfo createCid(String text, Multibase base) {
    // Create multihash
    MultihashInfo multihash = createMultihash(text);
    Uint8List multihashBytesArray = multihash.toBytes();

    // Adding suffixex to multihash
    // Currently, the suffix consists of version 1 and `raw` multicodec.
    int version = 0x01;
    int codecCode = 0x55;
    Uint8List suffixedMultihash = _addSuffixToMultihash(multihashBytesArray, version, codecCode);

    var codecObj = MultiCodecs.list().where((element) => element.code == codecCode).first;

    String cidString = encodeInputMultihashWithBase(base, suffixedMultihash);

    // Creating CIDInfo object to return
    CIDInfo cidInfo = CIDInfo(
        multihashDigest: multihash.digest,
        multihashName: multihash.name,
        multihashCode: multihash.code,
        multihashSize: multihash.size,
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

/// Adds a suffix to the multihash with the given [multihash] with the [version] and [codec].
///
/// These are part of the `CIDv1` hash. For more information about the information
/// that is present inside a `CIDv1` hash, check the [official IPFS](https://docs.ipfs.tech/concepts/content-addressing/#cid-versions) docs.
Uint8List _addSuffixToMultihash(Uint8List multihash, int version, int codec) {
  BytesBuilder b = BytesBuilder();

  // Adds the convention codes for the version and the codec.
  // These codes can be found in the canonical repo -> https://github.com/multiformats/multicodec/blob/master/table.csv
  b.add(Uint8List.fromList([version]));
  b.add(Uint8List.fromList([codec]));
  b.add(multihash);

  return b.toBytes();
}
