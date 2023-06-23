import 'dart:io';

import 'package:dart_cid/src/cid.dart';
import 'package:dart_cid/src/multibase.dart';
import 'package:random_string_generator/random_string_generator.dart';
import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

void main() {
  test('invalid code should yield an exception', () {

    expect(() => getMultibaseFromCode("a"), throwsException);

  }, tags: "unit");
}
