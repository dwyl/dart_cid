import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:collection/collection.dart';

import 'package:dart_cid/dart_cid.dart';

void main() {
  test('check encode and decode', () {
    var input = "Hello World";

    var bytes = utf8.encode(input); // data being hashed
    var digest = sha256.convert(bytes);
    var byte_array = Uint8List.fromList(digest.bytes);

    var encodedCuh = encode('sha2-256', byte_array, null);
    var decodedCuh = decode(encodedCuh);

    var eq = const ListEquality().equals;
    expect(eq(decodedCuh.digest, byte_array), true);
  });
}
