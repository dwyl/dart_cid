library dart_cid;

import 'dart:io';
import 'dart:math';

import 'package:buffer/buffer.dart';
import 'package:dart_cid/constants.dart';
import 'package:flutter/foundation.dart';

HashInfo _coerceCode(String hashFunction) {
  if (!supportedHashFunctions.contains(hashFunction)) {
    throw Exception('Unsupported hash.');
  }

  return hashTable.firstWhere((obj) => obj.hashName == hashFunction);
}

// Converts an int value to a varint (in Dart this is expressed as Uint8List - an array of bytes)
// This is an implementation of varint (changed for unsigned ints) -> https://github.com/fmoo/python-varint/blob/master/varint.py
// https://pub.dev/documentation/viz_transaction/latest/viz_transaction/BinaryUtils/transformInt16ToBytes.html
Uint8List _encodeVarint(int value) {
  ByteDataWriter writer = ByteDataWriter();

  do {
    int temp = value & 0x7F; //0x7F = 01111111

    value = (value >> 7) & 0x01FFFFFFFFFFFFFF; // unsigned bit-right shift

    if (value != 0) {
      temp |= 0x80;
    }

    writer.writeUint8(temp.toInt());
  } while (value != 0);

  return writer.toBytes();
}

//TODO might be relevant to change the encoding as well *remove the unsigned part?)
/// Decodes the first from the beggining of the buffer.
/// Adapted from https://github.com/multiformats/js-multihash
DecodedVarInt _decodeVarint(Uint8List buf, int? p_offset) {
  var res = 0;
  int offset = p_offset ?? 0;
  int shift = 0;
  int counter = offset;
  int b;
  int l = buf.length;
  int bytes_read_ctr = 0;

  do {
    if (counter >= l || shift > 49) {
      throw RangeError('Could not decode varint');
    }
    b = buf[counter++];
    if (shift < 28) {
      res += (b & 0x7F) << shift;
    } else {
      res += (b & 0x7F) * pow(2, shift).toInt();
    }
    shift += 7;
  } while (b >= 0x80);

  bytes_read_ctr = counter - offset;

  return DecodedVarInt(res: res, byteLength: bytes_read_ctr);
}

/// Encode a digest with multihash
Uint8List encode(String hashType, Uint8List digest, int? length) {
  HashInfo hashInfo = _coerceCode(hashType);

  length ??= digest.length;
  if (length != digest.length) {
    throw Exception('Digest length has to be equal to the specified length.');
  }

  var b = BytesBuilder();
  b.add(_encodeVarint(hashInfo.code));
  b.add(_encodeVarint(length));
  b.add(digest);

  return b.toBytes();
}

/// Decodes an array of bytes into a multihash object
Multihash decode(Uint8List bytes) {
  if (bytes.length < 3) {
    throw Exception('Multihash must be greater than 3 bytes.');
  }

  var decodedCode = _decodeVarint(bytes, null);
  if (!supportedHashCodes.contains(decodedCode.res)) {
    throw Exception(
        'Multihash unknown function code: 0x${decodedCode.res.toRadixString(16)}');
  }

  bytes = bytes.sublist(decodedCode.byteLength);

  final decodedLen = _decodeVarint(bytes, null);
  if (decodedLen.res < 0) {
    throw Exception('Multihash invalid length: ${decodedLen.res}');
  }

  bytes = bytes.sublist(decodedLen.byteLength);
  if (bytes.length != decodedLen.byteLength) {
    throw Exception('Multihash inconsistent length');
  }

  String hashName =
      hashTable.firstWhere((obj) => obj.code == decodedCode.res).hashName;

  return Multihash(
      code: decodedCode.res,
      length: decodedLen.res,
      hashName: hashName,
      digest: bytes);
}
