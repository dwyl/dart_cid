import 'package:dart_cid/src/decode_cid.dart';
import 'package:dart_cid/src/multibase.dart';
import 'package:test/test.dart';
import 'dart:typed_data';

void main() {
  test('CIDv0 CIDs may not be multibase encoded and with 0x12 should throw', () {
    String input = "f12551220b94d27b9934d3e08a52e52d7da7dabfac484efe37a5380ee9088f7ace2efcde9";

    expect(() => decodeCIDStringInformation(input), throwsException);
  }, tags: "unit");

  test('Multicodec code is not supported.', () {
    Uint8List input = Uint8List.fromList([1, -1, 18, 32, 185, 77, 39, 185, 147, 77, 62, 8, 165, 46, 82, 215, 218, 125, 171, 250, 196, 132, 239, 227, 122, 83, 128, 238, 144, 136, 247, 172, 226, 239, 205, 233]);

    expect(() => decodeCIDStringInformationStep2(input, Multibase.base16), throwsException);
  }, tags: "unit");

  test('Multicodec version cannot be malformed', () {
    Uint8List input = Uint8List.fromList([0, -1, 18, 32, 185, 77, 39, 185, 147, 77, 62, 8, 165, 46, 82, 215, 218, 125, 171, 250, 196, 132, 239, 227, 122, 83, 128, 238, 144, 136, 247, 172, 226, 239, 205, 233]);

    expect(() => decodeCIDStringInformationStep2(input, Multibase.base16), throwsException);
  }, tags: "unit");

  test('Multicodec version cannot be bigger than 1', () {
    Uint8List input = Uint8List.fromList([4, -1, 18, 32, 185, 77, 39, 185, 147, 77, 62, 8, 165, 46, 82, 215, 218, 125, 171, 250, 196, 132, 239, 227, 122, 83, 128, 238, 144, 136, 247, 172, 226, 239, 205, 233]);

    expect(() => decodeCIDStringInformationStep2(input, Multibase.base16), throwsException);
  }, tags: "unit");

  test('Multibase code is not supported.', () {
    expect(() => getMultibaseFromCode(""), throwsException);
  }, tags: "unit");
}


