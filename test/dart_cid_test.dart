import 'package:flutter_test/flutter_test.dart';

import 'package:dart_cid/dart_cid.dart';

void main() {
  test('test creating cid with \'hello world \' with base58 encoding', () {
    String input = 'hello world';
    final output = createCid(input, BASE.base58);

    // https://cid.ipfs.tech/#zb2rhj7crUKTQYRGCRATFaQ6YFLTde2YzdqbbhAASkL9uRDXn
    expect(output == "zb2rhj7crUKTQYRGCRATFaQ6YFLTde2YzdqbbhAASkL9uRDXn", true);
  });

  test('test creating cid with \'hello world \' with base32 encoding', () {
    String input = 'hello world';
    final output = createCid(input, BASE.base32);

    // https://cid.ipfs.tech/#BAFKREIFZJUT3TE2NHYEKKLSS27NH3K72YSCO7Y32KOAO5EEI66WOF36N5E
    expect(output == "BAFKREIFZJUT3TE2NHYEKKLSS27NH3K72YSCO7Y32KOAO5EEI66WOF36N5E", true);
  });
}
