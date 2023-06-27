import 'dart:math' show pow;
import 'dart:typed_data';

/// Util class used to fetch the leading variable integer of a stream/array of bytes.
///
/// [res] refers to the leading byte converted to an integer
/// and [numBytesRead] refers to the number of bytes that it occupies in the array of bytes.
class DecodedVarInt {
  final int res;
  final int numBytesRead;

  DecodedVarInt({required this.res, required this.numBytesRead});
}

/// Receives a buffer [buf] and decodes the first leading varint.
///
/// Adapted from https://github.com/multiformats/js-multihash.
DecodedVarInt decodeVarint(Uint8List buf, {int? nOffset}) {
  int res = 0;
  int offset = nOffset ?? 0;
  int shift = 0;
  int counter = offset;
  int b;
  int l = buf.length;
  int bytesReadCounter = 0;

  do {
    if (counter >= l || shift > 49) {
      throw RangeError('Could not decode varint.');
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
