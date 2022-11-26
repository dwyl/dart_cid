import 'package:flutter_test/flutter_test.dart';

import 'package:dart_cid/dart_cid.dart';

void main() {
  test('test creating cid with \'hello world \' with base58 encoding', () {
    String input = 'hello world';
    final output = createCid(input, BASE.base58);

    // https://cid.ipfs.tech/#zb2rhj7crUKTQYRGCRATFaQ6YFLTde2YzdqbbhAASkL9uRDXn
    expect(output == "zb2rhj7crUKTQYRGCRATFaQ6YFLTde2YzdqbbhAASkL9uRDXn", true);
  });
}
