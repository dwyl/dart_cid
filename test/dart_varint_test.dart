import 'dart:typed_data';

import 'package:dart_cid/src/utils.dart';
import 'package:test/test.dart';

void main() {
  test('decoding varint', () {
    // The following is input byte array and the correspondent value.
    int inputValue = 3463580742760;
    Uint8List inputValueInByteArray = Uint8List.fromList([232, 232, 255, 235, 230, 100]);

    var output = decodeVarint(inputValueInByteArray);

    expect(output.res, equals(inputValue));
  });

  test('decoding varint invalid varint (out of bounds)', () {
    Uint8List input = Uint8List.fromList([232, 232, 255, 235, 230, 150]); // this varint is not finished being defined
    expect(() => decodeVarint(input), throwsA(TypeMatcher<RangeError>()));
  });
}