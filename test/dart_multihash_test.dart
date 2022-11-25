import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:collection/collection.dart';

import 'package:dart_cid/dart_multihash.dart';

void main() {
  test('check encode and decode', () {
    var input = "Hello World";

    var bytes = utf8.encode(input); // data being hashed
    var digest = sha256.convert(bytes);
    var inputByteArray = Uint8List.fromList(digest.bytes);

    var encodedObj = encode('sha2-256', inputByteArray, null);
    var decodedObj = decode(encodedObj);

    var eq = const ListEquality().equals;
    expect(eq(decodedObj.digest, inputByteArray), true);
  });
}
