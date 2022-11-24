library dart_cid;

import 'dart:io';

import 'package:buffer/buffer.dart';
import 'package:dart_cid/constants.dart';
import 'package:flutter/foundation.dart';

class MultiHash {
  /// Gets hash info to be encoded according to a string stating the hash type
  HashInfo _coerceCode(String hashFunction) {
    if (!supportedHashFunctions.contains(hashFunction)) {
      throw Exception('Unsupported hash.');
    }

    return hashTable.firstWhere((obj) => obj.hash == hashFunction);
  }

  // Converts an int value to a varint (in Dart this is expressed as Uint8List - an array of bytes)
  // This is an implementation of varint (changed for unsigned ints) -> https://github.com/fmoo/python-varint/blob/master/varint.py
  Uint8List _varintDecode(int value) {
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

  /// Encode a digest with multihash
  Uint8List encode(String hashType, Uint8List digest, int? length) {
    HashInfo hashInfo = _coerceCode(hashType);

    length ??= digest.length;
    if (length != digest.length) {
      throw Exception('Digest length has to be equal to the specified length.');
    }

    var b = BytesBuilder();
    b.add(_varintDecode(hashInfo.code));
    b.add(_varintDecode(length));
    b.add(digest);

    return b.toBytes();
  }
}
