library dart_cid;

import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:dart_cid/multihash/dart_multihash.dart';
import 'package:flutter/foundation.dart';

import 'package:base32/base32.dart';
import 'package:bs58/bs58.dart';

String create_cid(String text) {
  List<int> bytes = utf8.encode(text);
  var digest = Uint8List.fromList(sha256.convert(bytes).bytes);

  var multihash = Multihash().encode("sha2-256", digest, null);

  var b = BytesBuilder();
  b.add(Uint8List.fromList([0x01])); // adds version of cid (cidv1)
  b.add(Uint8List.fromList([0x55])); // adds 'raw' codec to the multihash
  b.add(multihash);
  var hash_with_codec_and_version = b.toBytes();

  var encoded = base58.encode(hash_with_codec_and_version);

  var ret = "z" + encoded; // adding suffix for base 58 z
  return ret;
}
