import 'dart:typed_data';

import 'package:dart_cid/dart_cid.dart';
import 'package:dart_cid/src/multibase.dart';
import 'package:dart_cid/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group("Converting to CIDv1", () {
    test('converting CIDv0 to CIDv1', () {
      // For context, check https://proto.school/anatomy-of-a-cid/06.
      // In short, QmcRD4wkPPi6dig81r5sLj9Zm1gDCL4zgpEj9CfuRrGbzF is a CIDv0
      var v0Cid = "QmcRD4wkPPi6dig81r5sLj9Zm1gDCL4zgpEj9CfuRrGbzF";
      var obj = CID.decodeCid(v0Cid);

      expect(obj.multicodecName, equals("dag-pb"));
      expect(obj.multicodecCode, equals(112));
      expect(obj.multibase.baseName, equals("base58btc"));
      expect(obj.multihashInfo.name, equals("sha2-256"));
      expect(obj.version, equals(0));

      obj.toV1();

      // If checking the inspector, we can see this is the equivalent CIDv1 in base32.
      // https://cid.ipfs.tech/#bafybeigrf2dwtpjkiovnigysyto3d55opf6qkdikx6d65onrqnfzwgdkfa
      expect(
          obj.cid,
          equals(
              "bafybeigrf2dwtpjkiovnigysyto3d55opf6qkdikx6d65onrqnfzwgdkfa"));
      expect(obj.multibase, equals(Multibase.base32));
      expect(obj.version, equals(1));
    }, tags: "unit");

    test('converting CIDv0 to CIDv1 with different base', () {
      // For context, check https://proto.school/anatomy-of-a-cid/06.
      // In short, QmcRD4wkPPi6dig81r5sLj9Zm1gDCL4zgpEj9CfuRrGbzF is a CIDv0
      var v0Cid = "QmcRD4wkPPi6dig81r5sLj9Zm1gDCL4zgpEj9CfuRrGbzF";
      var obj = CID.decodeCid(v0Cid);

      expect(obj.multicodecName, equals("dag-pb"));
      expect(obj.multicodecCode, equals(112));
      expect(obj.multibase.baseName, equals("base58btc"));
      expect(obj.multihashInfo.name, equals("sha2-256"));
      expect(obj.version, equals(0));

      obj.toV1(base: Multibase.base58btc);

      // https://cid.ipfs.tech/#zdj7WjWTSNpEsBhWRz3kb3VD6z8PDseusV8Z8eFp14aFHqWAB
      expect(
          obj.cid, equals("zdj7WjWTSNpEsBhWRz3kb3VD6z8PDseusV8Z8eFp14aFHqWAB"));
      expect(obj.version, equals(1));
    }, tags: "unit");

    test('converting CIDv1 to CIDv1 should do nothing', () {
      // https://cid.ipfs.tech/#bafybeigrf2dwtpjkiovnigysyto3d55opf6qkdikx6d65onrqnfzwgdkfa
      var v1Cid = "bafybeigrf2dwtpjkiovnigysyto3d55opf6qkdikx6d65onrqnfzwgdkfa";
      var obj = CID.decodeCid(v1Cid);

      expect(obj.multicodecName, equals("dag-pb"));
      expect(obj.multicodecCode, equals(112));
      expect(obj.multibase.baseName, equals("base32"));
      expect(obj.multihashInfo.name, equals("sha2-256"));
      expect(obj.version, equals(1));

      obj.toV1();

      // Object should be the same
      expect(obj.cid, equals(v1Cid));
      expect(obj.multicodecName, equals("dag-pb"));
      expect(obj.multicodecCode, equals(112));
      expect(obj.multibase.baseName, equals("base32"));
      expect(obj.multihashInfo.name, equals("sha2-256"));
      expect(obj.version, equals(1));
    }, tags: "unit");

    test('converting invalid CID version to v1', () {
      // https://cid.ipfs.tech/#bafybeigrf2dwtpjkiovnigysyto3d55opf6qkdikx6d65onrqnfzwgdkfa
      var v1Cid = "bafybeigrf2dwtpjkiovnigysyto3d55opf6qkdikx6d65onrqnfzwgdkfa";
      var obj = CID.decodeCid(v1Cid);

      // Make invalid operation
      obj.version = 10;

      // Try to convert to v1 after making invalid version change operation
      expect(() => obj.toV1(), throwsException);
    }, tags: "unit");
  });

  /*
  group("Converting to CIDv0", () {
        test('converting CIDv1 to CIDv0', () {
      // For context, check https://proto.school/anatomy-of-a-cid/06.
      // In short, zdj7WjWTSNpEsBhWRz3kb3VD6z8PDseusV8Z8eFp14aFHqWAB is a CIDv1
      var v1Cid = "zdj7WjWTSNpEsBhWRz3kb3VD6z8PDseusV8Z8eFp14aFHqWAB";
      var obj = CID.decodeCid(v1Cid);

      expect(obj.multicodecName, equals("dag-pb"));
      expect(obj.multicodecCode, equals(112));
      expect(obj.multibase.baseName, equals("base58btc"));
      expect(obj.multihashInfo.name, equals("sha2-256"));
      expect(obj.version, equals(1));

      obj.toV0();

      // If checking the inspector, we can see this is the equivalent CIDv0.
      // https://cid.ipfs.tech/#QmdfTbBqBPQ7VNxZEYEj14VmRuZBkqFbiwReogJgS1zR1n
      expect(obj.cid, equals("QmdfTbBqBPQ7VNxZEYEj14VmRuZBkqFbiwReogJgS1zR1n"));
      expect(obj.multibase, equals(Multibase.base32));
      expect(obj.version, equals(1));
    }, tags: "unit");
  });
  */
}
