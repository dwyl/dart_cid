import 'package:random_string_generator/random_string_generator.dart';
import 'package:test/test.dart';
import 'dart:io';

import 'package:test_process/test_process.dart';

import 'package:dart_cid/src/cid.dart';

void main() {
  group("Regular tests", () {
    test('creating cid with \'hello world \' with base58 encoding', () {
      String input = 'hello world';
      final output = Cid.createCid(input, BASE.base58);

      // https://cid.ipfs.tech/#zb2rhj7crUKTQYRGCRATFaQ6YFLTde2YzdqbbhAASkL9uRDXn
      expect(output == "zb2rhj7crUKTQYRGCRATFaQ6YFLTde2YzdqbbhAASkL9uRDXn", true);
    }, tags: "unit");

    test('creating cid with \'hello world \' with base32 encoding', () {
      String input = 'hello world';
      final output = Cid.createCid(input, BASE.base32);

      // https://cid.ipfs.tech/#BAFKREIFZJUT3TE2NHYEKKLSS27NH3K72YSCO7Y32KOAO5EEI66WOF36N5E
      expect(output == "BAFKREIFZJUT3TE2NHYEKKLSS27NH3K72YSCO7Y32KOAO5EEI66WOF36N5E", true);
    }, tags: "unit");

    test('different cids when input value is different', () {
      String input1 = 'divinity';
      String input2 = 'something comforting';
      final output1 = Cid.createCid(input1, BASE.base32);
      final output2 = Cid.createCid(input2, BASE.base32);

      expect(output1 == output2, false);
    }, tags: "unit");

    test('empty values should yield results', () {
      String input = '';
      final output1 = Cid.createCid(input, BASE.base32);
      final output2 = Cid.createCid(input, BASE.base58);

      expect(output1, isNotEmpty);
      expect(output1 == 'BAFKREIHDWDCEFGH4DQKJV67UZCMW7OJEE6XEDZDETOJUZJEVTENXQUVYKU', true);
      expect(output2, isNotEmpty);
      expect(output2 == 'zb2rhmy65F3REf8SZp7De11gxtECBGgUKaLdiDj7MCGCHxbDW', true);
    }, tags: "unit");
  });

  group("Property-based tests from IPFS", () {
    String fileName = "testfile.txt"; // name of the file to test with `ipfs add`
    int iterations = 1; // small number of iterations because a process can hang

    test('compare cid with IPFS-created cid X times (according to `iterations`)', () async {
      
      // Creating a 10-sized list of random strings
      RandomStringGenerator generator = RandomStringGenerator(
        fixedLength: 10,
      );

      List<String> randomStrings = List<String>.filled(iterations, '').map((e) => generator.generate()).toList();

      // Run test X iterations
      for (var inputString in randomStrings) {
        var ret = await comparedPackageWithIPFSCid(inputString, fileName);
        expect(ret.ipfsCid == ret.packageCid.toLowerCase(), true);
      }
    }, tags: "ipfs");

    // Delete file after all tests are run, in case it exists
    tearDownAll(() async {
      final file = File(fileName);
      final fileExists = await file.exists();
      if (fileExists) {
        file.delete();
      }
    });
  });
}

class CidComparison {
  final String packageCid;
  final String? ipfsCid;

  const CidComparison({required this.packageCid, required this.ipfsCid});
}

/// Creates a file with a given [inputString]
/// and runs `ipfs add [fileName] -n --cid-version=1`
/// which yields a cid created for the file.
///
/// This function compares the cid returned from IPFS
/// with the one generated from the package.
Future<CidComparison> comparedPackageWithIPFSCid(String inputString, String fileName) async {
  var myFile = await File(fileName).create();

  // Adds content to file
  myFile.writeAsString(inputString);

  // Run `ipfs add file.txt -n --cid-version=1
  TestProcess process = await TestProcess.start('ipfs', ['add', fileName, "-n", "--cid-version=1"]);
  String processStdout = await process.stdoutStream().first; // get first line of stdout
  final regex = RegExp(r'^added(.*) (.*)$');
  final match = regex.firstMatch(processStdout);

  // Cid returned from running the command
  final ipfsCid = match?.group(1)?.trim();
  final packageCid = Cid.createCid(inputString, BASE.base32);

  // Cleanup
  await process.kill();
  myFile.delete();

  return CidComparison(ipfsCid: ipfsCid, packageCid: packageCid);
}
