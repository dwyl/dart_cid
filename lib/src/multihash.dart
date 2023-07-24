import 'dart:typed_data';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dart_cid/src/decode_cid.dart';
import 'package:dart_cid/src/multibase.dart';
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