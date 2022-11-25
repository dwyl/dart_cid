import 'dart:math' show pow;

import 'package:buffer/buffer.dart';
import 'package:flutter/foundation.dart';

import 'models.dart';

/// Converts an int value to a varint (in Dart this is expressed as Uint8List - an array of bytes)
/// This is an implementation of varint (changed for unsigned ints) based of https://github.com/fmoo/python-varint/blob/master/varint.py
/// that is changed for unsigned integers.
Uint8List encodeVarint(int value) {
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

/// Receives a buffer [buf] and decodes the first leading varint.
///
/// Adapted from https://github.com/multiformats/js-multihash.
DecodedVarInt decodeVarint(Uint8List buf, int? nOffset) {
  int res = 0;
  int offset = nOffset ?? 0;
  int shift = 0;
  int counter = offset;
  int b;
  int l = buf.length;
  int bytesReadCounter = 0;

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

  bytesReadCounter = counter - offset;

  return DecodedVarInt(res: res, numBytesRead: bytesReadCounter);
}
