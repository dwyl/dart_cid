import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:collection/collection.dart';

import 'package:dart_cid/dart_multihash.dart';

void main() {
  test('encoding and decoding a string', () {
    var input = "Hello World";

    var bytes = utf8.encode(input); // data being hashed
    var digest = sha256.convert(bytes);
    var inputByteArray = Uint8List.fromList(digest.bytes);

    var encodedObj = encode('sha2-256', inputByteArray, null);
    var decodedObj = decode(encodedObj);

    var eq = const ListEquality().equals;
    expect(eq(decodedObj.digest, inputByteArray), true);
  });

  test('encoding with an unsupported hash function type', () {
    var input = "Hello World";

    var bytes = utf8.encode(input); // data being hashed
    var digest = sha256.convert(bytes);
    var inputByteArray = Uint8List.fromList(digest.bytes);

    expect(() => encode('invalid_hash_type', inputByteArray, null), throwsA(TypeMatcher<UnsupportedError>()));
  });

  test('encoding with an incorrect length', () {
    var input = "Hello World";

    var bytes = utf8.encode(input); // data being hashed
    var digest = sha256.convert(bytes);
    var inputByteArray = Uint8List.fromList(digest.bytes);

    expect(() => encode('sha2-256', inputByteArray, 1), throwsA(TypeMatcher<RangeError>()));
  });
}
