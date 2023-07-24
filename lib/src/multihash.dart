import 'dart:typed_data';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dart_multihash/dart_multihash.dart';

/// Creates a [Multihash](https://multiformats.io/multihash/) hashed string
/// with the given input.
///
/// It hashes the input string with `sha2-256` and suffixes it with the
/// correspondent Multiformat convention code.
MultihashInfo createMultihash(String text) {
  const multihashName = 'sha2-256';

  // Get the array of bytes from the given text
  List<int> bytes = utf8.encode(text);

  // Hash the inp ut string with sha2-256 algorithm and convert it to array of bytes
  Digest digestObj = sha256.convert(bytes);
  Uint8List digest = Uint8List.fromList(digestObj.bytes);

  // Multihashes the hashed string with the `sha2-256` multiformat code.
  return Multihash.encode(multihashName, digest);
}

/// Adds a suffix to the multihash with the given [multihash] with the [version] and [codec].
///
/// These are part of the `CIDv1` hash. For more information about the information
/// that is present inside a `CIDv1` hash, check the [official IPFS](https://docs.ipfs.tech/concepts/content-addressing/#cid-versions) docs.
Uint8List addSuffixToMultihash(Uint8List multihash, int version, int codec) {
  BytesBuilder b = BytesBuilder();

  // Adds the convention codes for the version and the codec.
  // These codes can be found in the canonical repo -> https://github.com/multiformats/multicodec/blob/master/table.csv
  b.add(Uint8List.fromList([version]));
  b.add(Uint8List.fromList([codec]));
  b.add(multihash);

  return b.toBytes();
}
