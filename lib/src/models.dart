/// Class that holds the information of the provided `cid`.
class CIDInfo {
  // Multihash
  final List<int> multihashDigest;
  final String multihashName;
  final int multihashCode;
  final int multihashSize;

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
      {required this.multihashDigest,
      required this.multihashName,
      required this.multihashCode,
      required this.multihashSize,
      required this.multicodecName,
      required this.multicodecCode,
      required this.multibase,
      required this.version,
      required this.cid});
}