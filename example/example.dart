import 'package:dart_cid/dart_cid.dart';

// Creating a v1 CID.
String input = 'hello world';
CIDInfo output = CID.createCid(input, Multibase.base58btc);

var cid = output.cid;
// "zb2rhj7crUKTQYRGCRATFaQ6YFLTde2YzdqbbhAASkL9uRDXn"

// Decoding a given CID
String v0Cid = 'QmcRD4wkPPi6dig81r5sLj9Zm1gDCL4zgpEj9CfuRrGbzF';
var decodedV0CID = CID.decodeCid(v0Cid);

// Convert a given CID object to v1
var v1Cid = CID.decodeCid(v0Cid).toV1();
var cidString = v1Cid.cid;
// "bafybeigrf2dwtpjkiovnigysyto3d55opf6qkdikx6d65onrqnfzwgdkfa"
