import 'dart:typed_data';

import 'package:dart_cid/dart_cid.dart';
import 'package:dart_cid/src/multibase.dart';
import 'package:dart_cid/src/utils.dart';
import 'package:test/test.dart';

void main() {
  test('converting CIDv0 to CIDv1', () {
    // For context, check https://proto.school/anatomy-of-a-cid/06.
    // In short, QmcRD4wkPPi6dig81r5sLj9Zm1gDCL4zgpEj9CfuRrGbzF is a CIDv0
    var v0Cid = "QmcRD4wkPPi6dig81r5sLj9Zm1gDCL4zgpEj9CfuRrGbzF";
    var obj = CID.decodeCid(v0Cid);

    expect(obj.multicodecName, equals("dag-pb"));
    expect(obj.multicodecCode, equals(112));
    expect(obj.multibase.baseName, equals("base58btc"));
    expect(obj.multihashInfo.name, equals("sha2-256"));

    obj.toV1();

    // If checking the inspector, we can see this is the equivalent CIDv1 in base32. 
    // https://cid.ipfs.tech/#QmcRD4wkPPi6dig81r5sLj9Zm1gDCL4zgpEj9CfuRrGbzF
    expect(obj.cid, equals("bafybeigrf2dwtpjkiovnigysyto3d55opf6qkdikx6d65onrqnfzwgdkfa"));
    expect(obj.multibase, equals(Multibase.base32));
    expect(obj.version, equals(1));
  }, tags: "unit");
}
