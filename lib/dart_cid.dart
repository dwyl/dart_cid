library dart_cid;

import 'dart:io';

import 'package:dart_cid/src/constants.dart';
import 'package:dart_cid/src/varintUtils.dart';
import 'package:flutter/foundation.dart';

import 'src/models.dart';

/// Encodes a digest with a passed hash function type.
Uint8List encode(String hashType, Uint8List digest, int? length) {
  // Checking if hash function type is supported
  if (!supportedHashFunctions.contains(hashType)) {
    throw Exception('Unsupported hash function type.');
  }

  // Function convention info
  HashFunctionConvention hashInfo = hashTable.firstWhere((obj) => obj.hashFunctionName == hashType);

  // Check if length of digest is correctly defined.
  length ??= digest.length;
  if (length != digest.length) {
    throw Exception('Digest length has to be equal to the specified length.');
  }

  // Building the array of bytes with hash function type, length of digest and digest encoded.
  var b = BytesBuilder();
  b.add(encodeVarint(hashInfo.code));
  b.add(encodeVarint(length));
  b.add(digest);

  return b.toBytes();
}

/// Decodes an array of bytes into a multihash object.
MultihashInfo decode(Uint8List bytes) {
  // Check if the array of bytes is long enough (has to have hash function type, length of digest and digest)
  if (bytes.length < 3) {
    throw Exception('Multihash must be greater than 3 bytes.');
  }

  // Decode code of hash function type
  var decodedCode = decodeVarint(bytes, null);
  if (!supportedHashCodes.contains(decodedCode.res)) {
    throw Exception('Multihash unknown function code: 0x${decodedCode.res.toRadixString(16)}');
  }

  bytes = bytes.sublist(decodedCode.numBytesRead);

  // Decode length of digest
  final decodedLen = decodeVarint(bytes, null);
  if (decodedLen.res < 0) {
    throw Exception('Multihash invalid length: ${decodedLen.res}');
  }

  // Get digest
  bytes = bytes.sublist(decodedLen.numBytesRead);
  if (bytes.length != decodedLen.res) {
    throw Exception('Multihash inconsistent length');
  }

  // Fetch name of hash function type referring to the code
  String hashName = hashTable.firstWhere((obj) => obj.code == decodedCode.res).hashFunctionName;

  return MultihashInfo(code: decodedCode.res, length: decodedLen.res, hashFunctionName: hashName, digest: bytes);
}
