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
  final int version;

  // Multibase
  final Multibase multibase;

  // CID string
  final String cid;

  CIDInfo(
      {required this.multihashInfo,
      required this.multicodecName,
      required this.multicodecCode,
      required this.multibase,
      required this.version,
      required this.cid});

  /*
  toV1() {
    switch (version) {
      case 0: {

        // Get multihash as array of bytes
        Uint8List multihashBytesArray = multihashInfo.toBytes();

        // Adding suffixes to multihash
        // The new CID will have a suffix of version 1 and the given multicodec
        Uint8List suffixedMultihash = addSuffixToMultihash(multihashBytesArray, 1, multicodecCode);

        String cidString = encodeInputMultihashWithBase(base, suffixedMultihash);

        const { code, digest } = this.multihash
        const multihash = Digest.create(code, digest)
        return /** @type {CID<Data, Format, Alg, 1>} */ (
          CID.createV1(this.code, multihash)
        )
      }
      case 1: {
        return this;
      }
      default: {
        throw Exception("Can not convert CID version $version to version 1. This is a bug please report.");
      }
    }
  }
  */
}