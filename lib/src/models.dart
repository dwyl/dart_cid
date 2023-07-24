import 'dart:typed_data';

import 'package:dart_multihash/dart_multihash.dart';

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
  final String multibase;

  // CID
  final String cid;

  CIDInfo(
      {required this.multihashInfo,
      required this.multicodecName,
      required this.multicodecCode,
      required this.multibase,
      required this.version,
      required this.cid});


}