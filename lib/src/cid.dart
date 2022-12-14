import 'dart:ffi';
import 'dart:typed_data';

import 'package:base32/encodings.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:base32/base32.dart';
import 'package:bs58/bs58.dart';
import 'package:dart_multihash/dart_multihash.dart';

enum BASE { base32, base58 }

/// Class that contains the functions to create a `cid`.
class Cid {
  /// Creates a [`cid`](https://docs.ipfs.tech/concepts/content-addressing/#what-is-a-cid) v1
  /// that is compliant with IPFS standards
  /// The returned `cid` consists of a `sha2-256` multihash, a `raw` multicodec and base encoded either 32 or 58.
  static String createCid(String text, BASE base) {
    Uint8List multihash = _createMultihash(text);
    Uint8List suffixedMultihash = _addSuffixToMultihash(multihash);

    if (base == BASE.base32) {
      return _base32Encode(suffixedMultihash);
    } else {
      return _base58Encode(suffixedMultihash);
    }
  }
}

/// Adds a suffix to the multihash.
///
/// Currently, the suffix consists of `CIDv1` **version code** and `raw` multicodec.
/// These are part of the `CIDv1` hash. For more information about the information
/// that is present inside a `CIDv1` hash, check the [official IPFS](https://docs.ipfs.tech/concepts/content-addressing/#cid-versions) docs.
Uint8List _addSuffixToMultihash(Uint8List multihash) {
  BytesBuilder b = BytesBuilder();

  // Adds the convention codes for the version and the codec.
  // These codes can be found in the canonical repo -> https://github.com/multiformats/multicodec/blob/master/table.csv
  b.add(Uint8List.fromList([0x01])); // adds version of cid (cidv1)
  b.add(Uint8List.fromList([0x55])); // adds 'raw' codec to the multihash
  b.add(multihash);

  return b.toBytes();
}

/// Creates a [Multihash](https://multiformats.io/multihash/) hashed string
/// with the given input.
///
/// It hashes the input string with `sha2-256` and suffixes it with the
/// correspondent Multiformat convention code.
Uint8List _createMultihash(String text) {
  List<int> bytes = utf8.encode(text);

  // Hash the input string with sha2-256 algorithm and  convert it to array of bytes
  Digest digestObj = sha256.convert(bytes);
  Uint8List digest = Uint8List.fromList(digestObj.bytes);

  // Multihashes the hashed string with the `sha2-256` multiformat code.
  Uint8List multihash = Multihash.encode("sha2-256", digest);

  return multihash;
}

/// Base58 encodes the given [suffixedMultihash].
/// It appends the 'z' character to the string, according to the
/// [`multibase` table](https://github.com/multiformats/multibase#multibase-table)
String _base58Encode(Uint8List suffixedMultihash) {
  String encodedHash = base58.encode(suffixedMultihash);

  // Suffixing the encoded hash with 'z'
  return "z$encodedHash";
}

/// Base32 encodes the given [suffixedMultihash].
/// It appends the 'B' character to the string, according to the
/// [`multibase` table](https://github.com/multiformats/multibase#multibase-table)
/// It uses the `standardRFC4648` uppercase version which is **case-insensitive** and **has no padding**.
String _base32Encode(Uint8List suffixedMultihash) {
  String encodedHash = base32.encode(suffixedMultihash, encoding: Encoding.standardRFC4648);
  String padlessEncodedHash = encodedHash.replaceAll("=", "");

  // Suffixing the encoded hash with 'z'
  return "B$padlessEncodedHash";
}
