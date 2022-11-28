import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

import 'package:test_process/test_process.dart';

import 'package:dart_cid/dart_cid.dart';

void main() {
  group("Regular tests", () {
    test('creating cid with \'hello world \' with base58 encoding', () {
      String input = 'hello world';
      final output = createCid(input, BASE.base58);

      // https://cid.ipfs.tech/#zb2rhj7crUKTQYRGCRATFaQ6YFLTde2YzdqbbhAASkL9uRDXn
      expect(output == "zb2rhj7crUKTQYRGCRATFaQ6YFLTde2YzdqbbhAASkL9uRDXn", true);
    });

    test('creating cid with \'hello world \' with base32 encoding', () {
      String input = 'hello world';
      final output = createCid(input, BASE.base32);

      // https://cid.ipfs.tech/#BAFKREIFZJUT3TE2NHYEKKLSS27NH3K72YSCO7Y32KOAO5EEI66WOF36N5E
      expect(output == "BAFKREIFZJUT3TE2NHYEKKLSS27NH3K72YSCO7Y32KOAO5EEI66WOF36N5E", true);
    });

    test('different cids when input value is different', () {
      String input1 = 'divinity';
      String input2 = 'something comforting';
      final output1 = createCid(input1, BASE.base32);
      final output2 = createCid(input2, BASE.base32);

      expect(output1 == output2, false);
    });

    test('empty values should yield results', () {
      String input = '';
      final output1 = createCid(input, BASE.base32);
      final output2 = createCid(input, BASE.base58);

      expect(output1, isNotEmpty);
      expect(output1 == 'BAFKREIHDWDCEFGH4DQKJV67UZCMW7OJEE6XEDZDETOJUZJEVTENXQUVYKU', true);
      expect(output2, isNotEmpty);
      expect(output2 == 'zb2rhmy65F3REf8SZp7De11gxtECBGgUKaLdiDj7MCGCHxbDW', true);
    });
  });

  group("Property-based tests from IPFS", () {
    test('compare cid with IPFS-created cid', () async {
      // Creates file to test with IPFS
      String fileName = "testfile.txt";
      var myFile = await File(fileName).create();

      // Adds content to file
      var value = "hello world";
      myFile.writeAsString(value);

      // Run `ipfs add file.txt -n --cid-version=1
      TestProcess process = await TestProcess.start('ipfs', ['add', fileName, "-n", "--cid-version=1"]);
      String processStdout = await process.stdoutStream().first; // get first line of stdout
      final regex = RegExp(r'^added(.*) (.*)$');
      final match = regex.firstMatch(processStdout);

      // Cid returned from running the command
      final ipfsCid = match?.group(1)?.trim();
      final packageCid = createCid(value, BASE.base32);

      // Cleanup and assertions
      await process.shouldExit(0);
      myFile.delete();
      expect(ipfsCid == packageCid.toLowerCase(), true);
    });
  });
}
