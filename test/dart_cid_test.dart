import 'dart:io';

import 'package:cid/src/cid.dart';
import 'package:cid/src/models.dart';
import 'package:random_string_generator/random_string_generator.dart';
import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

void main() {
  group("Regular tests", () {
    test('creating cid with \'hello world \' with base58 encoding', () {
      String input = 'hello world';
      final output = CID.createCid(input, Multibase.base58btc).cid;

      // https://cid.ipfs.tech/#zb2rhj7crUKTQYRGCRATFaQ6YFLTde2YzdqbbhAASkL9uRDXn
      expect(output == "zb2rhj7crUKTQYRGCRATFaQ6YFLTde2YzdqbbhAASkL9uRDXn", true);
    }, tags: "unit");

    test('creating cid with \'hello world \' with base32 encoding', () {
      String input = 'hello world';
      final output = CID.createCid(input, Multibase.base32upper).cid;

      // https://cid.ipfs.tech/#BAFKREIFZJUT3TE2NHYEKKLSS27NH3K72YSCO7Y32KOAO5EEI66WOF36N5E
      expect(output == "BAFKREIFZJUT3TE2NHYEKKLSS27NH3K72YSCO7Y32KOAO5EEI66WOF36N5E", true);
    }, tags: "unit");

    test('different cids when input value is different', () {
      String input1 = 'divinity';
      String input2 = 'something comforting';
      final output1 = CID.createCid(input1, Multibase.base32);
      final output2 = CID.createCid(input2, Multibase.base32);

      expect(output1 == output2, false);
    }, tags: "unit");

    test('empty values should yield results', () {
      String input = '';
      final output1 = CID.createCid(input, Multibase.base32upper).cid;
      final output2 = CID.createCid(input, Multibase.base58btc).cid;

      expect(output1, isNotEmpty);
      expect(output1 == 'BAFKREIHDWDCEFGH4DQKJV67UZCMW7OJEE6XEDZDETOJUZJEVTENXQUVYKU', true);
      expect(output2, isNotEmpty);
      expect(output2 == 'zb2rhmy65F3REf8SZp7De11gxtECBGgUKaLdiDj7MCGCHxbDW', true);
    }, tags: "unit");

    test('decoding a CIDv0', () {
      // This is the code from https://docs.ipfs.tech/concepts/content-addressing/#cid-conversion.
      // See the inspector of this code in https://cid.ipfs.tech/#QmdfTbBqBPQ7VNxZEYEj14VmRuZBkqFbiwReogJgS1zR1n.
      String input = 'QmRKs2ZfuwvmZA3QAWmCqrGUjV9pxtBUDP3wuc6iVGnjA2';
      final output = CID.decodeCid(input);

      expect(output.multihashInfo.code, 0x12);
      expect(output.multihashInfo.name, "sha2-256");
      expect(output.multihashInfo.size, 256 / 8); // size in bytes
      expect(output.multicodecName, "dag-pb");
      expect(output.multicodecCode, 0x70);
      expect(output.multibase.baseName, "base58btc");
      expect(output.version, 0);
    }, tags: "unit");

    test('decoding a CIDv1', () {
      // See the inspector of this code in https://cid.ipfs.tech/#bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi.
      String input = 'bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi';
      final output = CID.decodeCid(input);

      expect(output.multihashInfo.code, 0x12);
      expect(output.multihashInfo.name, "sha2-256");
      expect(output.multihashInfo.size, 256 / 8); // size in bytes
      expect(output.multicodecName, "dag-pb");
      expect(output.multicodecCode, 0x70);
      expect(output.multibase.baseName, "base32");
      expect(output.version, 1);
    }, tags: "unit");
  });

  group("Encoding different CIDs:", () {
    test('base16', () {
      String input = 'hello world';
      final output = CID.createCid(input, Multibase.base16).cid;

      // See the inspector of this code in https://cid.ipfs.tech/#f01551220b94d27b9934d3e08a52e52d7da7dabfac484efe37a5380ee9088f7ace2efcde9.
      expect(output == "f01551220b94d27b9934d3e08a52e52d7da7dabfac484efe37a5380ee9088f7ace2efcde9", true);
    }, tags: "unit");

    test('base16upper', () {
      String input = 'hello world';
      final output = CID.createCid(input, Multibase.base16upper).cid;

      // See the inspector of this code in https://cid.ipfs.tech/#F01551220B94D27B9934D3E08A52E52D7DA7DABFAC484EFE37A5380EE9088F7ACE2EFCDE9.
      expect(output == "F01551220B94D27B9934D3E08A52E52D7DA7DABFAC484EFE37A5380EE9088F7ACE2EFCDE9", true);
    }, tags: "unit");

    test('base32upper', () {
      String input = 'hello world';
      final output = CID.createCid(input, Multibase.base32upper).cid;

      // See the inspector of this code in https://cid.ipfs.tech/#BAFKREIFZJUT3TE2NHYEKKLSS27NH3K72YSCO7Y32KOAO5EEI66WOF36N5E.
      expect(output == "BAFKREIFZJUT3TE2NHYEKKLSS27NH3K72YSCO7Y32KOAO5EEI66WOF36N5E", true);
    }, tags: "unit");

    test('base64', () {
      String input = 'hello world';
      final output = CID.createCid(input, Multibase.base64).cid;

      // See the inspector of this code in https://cid.ipfs.tech/#mAVUSILlNJ7mTTT4IpS5S19p9q/rEhO/jelOA7pCI96zi783p.
      expect(output == "mAVUSILlNJ7mTTT4IpS5S19p9q/rEhO/jelOA7pCI96zi783p", true);
    }, tags: "unit");
  });

  group("Decoding different CIDs:", () {
    test('raw binary, base16', () {
      // See the inspector of this code in https://cid.ipfs.tech/#f01551220b94d27b9934d3e08a52e52d7da7dabfac484efe37a5380ee9088f7ace2efcde9.
      String input = 'f01551220b94d27b9934d3e08a52e52d7da7dabfac484efe37a5380ee9088f7ace2efcde9';
      final output = CID.decodeCid(input);

      expect(output.multihashInfo.code, 0x12);
      expect(output.multihashInfo.name, "sha2-256");
      expect(output.multihashInfo.size, 256 / 8); // size in bytes
      expect(output.multicodecName, "raw");
      expect(output.multicodecCode, 0x55);
      expect(output.multibase.baseName, "base16");
      expect(output.version, 1);
    }, tags: "unit");

    test('raw binary, base16upper', () {
      // See the inspector of this code in https://cid.ipfs.tech/#F01551220B94D27B9934D3E08A52E52D7DA7DABFAC484EFE37A5380EE9088F7ACE2EFCDE9.
      String input = 'F01551220B94D27B9934D3E08A52E52D7DA7DABFAC484EFE37A5380EE9088F7ACE2EFCDE9';
      final output = CID.decodeCid(input);

      expect(output.multihashInfo.code, 0x12);
      expect(output.multihashInfo.name, "sha2-256");
      expect(output.multihashInfo.size, 256 / 8); // size in bytes
      expect(output.multicodecName, "raw");
      expect(output.multicodecCode, 0x55);
      expect(output.multibase.baseName, "base16upper");
      expect(output.version, 1);
    }, tags: "unit");

    test('raw binary, base32upper', () {
      // See the inspector of this code in https://cid.ipfs.tech/#BAFKREIFZJUT3TE2NHYEKKLSS27NH3K72YSCO7Y32KOAO5EEI66WOF36N5E.
      String input = 'BAFKREIFZJUT3TE2NHYEKKLSS27NH3K72YSCO7Y32KOAO5EEI66WOF36N5E';
      final output = CID.decodeCid(input);

      expect(output.multihashInfo.code, 0x12);
      expect(output.multihashInfo.name, "sha2-256");
      expect(output.multihashInfo.size, 256 / 8); // size in bytes
      expect(output.multicodecName, "raw");
      expect(output.multicodecCode, 0x55);
      expect(output.multibase.baseName, "base32upper");
      expect(output.version, 1);
    }, tags: "unit");

    test('raw binary, base58btc', () {
      // See the inspector of this code in https://cid.ipfs.tech/#zb2rhe5P4gXftAwvA4eXQ5HJwsER2owDyS9sKaQRRVQPn93bs.
      String input = 'zb2rhe5P4gXftAwvA4eXQ5HJwsER2owDyS9sKaQRRVQPn93bs';
      final output = CID.decodeCid(input);

      expect(output.multihashInfo.code, 0x12);
      expect(output.multihashInfo.name, "sha2-256");
      expect(output.multihashInfo.size, 256 / 8); // size in bytes
      expect(output.multicodecName, "raw");
      expect(output.multicodecCode, 0x55);
      expect(output.multibase.baseName, "base58btc");
      expect(output.version, 1);
    }, tags: "unit");

    test('raw binary, base64', () {
      // See the inspector of this code in https://cid.ipfs.tech/#mAVUSILlNJ7mTTT4IpS5S19p9q/rEhO/jelOA7pCI96zi783p.
      String input = 'mAVUSILlNJ7mTTT4IpS5S19p9q/rEhO/jelOA7pCI96zi783p';
      final output = CID.decodeCid(input);

      expect(output.multihashInfo.code, 0x12);
      expect(output.multihashInfo.name, "sha2-256");
      expect(output.multihashInfo.size, 256 / 8); // size in bytes
      expect(output.multicodecName, "raw");
      expect(output.multicodecCode, 0x55);
      expect(output.multibase.baseName, "base64");
      expect(output.version, 1);
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
  final packageCid = CID.createCid(inputString, Multibase.base32);

  // Cleanup
  await process.kill();
  myFile.delete();

  return CidComparison(ipfsCid: ipfsCid, packageCid: packageCid.cid);
}
