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
          Uint8List suffixedMultihash = addSuffixToMultihash(multihashBytesArray, newVersion, multicodecCode);

          // New CID string
          String newCIDString = encodeInputMultihashWithBase(base, suffixedMultihash);

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
          throw Exception("Can not convert CID version $version to version 1. This is a bug please report.");
        }
    }
  }
}
