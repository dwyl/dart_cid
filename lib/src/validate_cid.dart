import 'dart:ffi';
import 'dart:typed_data';

import 'package:base32/encodings.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:base32/base32.dart';
import 'package:bs58/bs58.dart';
import 'package:dart_multihash/dart_multihash.dart';

class CID {
  final Uint8List multihash;
  final String multicodec;
  final int version;

  CID({required this.multihash, required this.multicodec, required this.version});
}

/// Decodes a `cid` string.
/// It follows the official algorithm in https://github.com/multiformats/cid/blob/ef1b2002394b15b1e6c26c30545fd485f2c4c138/README.md#decoding-algorithm.
CID? decodeCIDStringInformation(String input) {
  // Check if string is 46 characters long and if starts with "Qm"
  if (input.length != 46 || input.substring(0, 2) == "Qm") {
    Uint8List decodedInput = base58.decode(input);
    return step2(decodedInput);
  }

  return null;
}

/// Refers to the `step2` of https://github.com/multiformats/cid/blob/ef1b2002394b15b1e6c26c30545fd485f2c4c138/README.md#decoding-algorithm
/// to decode a given `cid` string.
CID? step2(Uint8List binary) {
  // If it's 34 bytes long with the leading bytes [0x12, 0x20, ...], it's a CIDv0
  if (binary.length == 34 && binary[0] == 0x12 && binary[1] == 0x20) {
    return CID(multihash: binary, multicodec: "dag-pb", version: 0);
  }

  return null;
}
