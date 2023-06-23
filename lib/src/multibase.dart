import 'dart:convert';
import 'dart:typed_data';

import 'package:base32/base32.dart' as base32Library;
import 'package:base32/encodings.dart';
import 'package:bs58/bs58.dart';
import 'package:convert/convert.dart';

/// Not all multibase spec base types are supported by this library.
/// We support the `default` ones from the official repo in https://github.com/multiformats/multibase/blob/master/multibase.csv.
enum Multibase {
  /// hexadecimal
  base16(code: 'f', name: "base16"),

  /// hexadecimal
  base16upper(code: 'F', name: "base16upper"),

  /// rfc4648 case-insensitive - no padding
  base32(code: 'b', name: "base32"),

  /// rfc4648 case-insensitive - no padding
  base32upper(code: 'B', name: "base32upper"),

  /// base58 bitcoin
  base58btc(code: 'z', name: "base58btc"),

  /// rfc4648 no padding
  base64(code: 'm', name: "base64"),

  /// rfc4648 no padding
  base64url(code: 'u', name: "base64url"),

  /// rfc4648 with padding
  base64urlpad(code: 'U', name: "base64urlpad", padding: '=');

  /// Initialize a new multibase variant
  const Multibase({
    required final String code,
    required final String name,
    final String padding = '',
  })  : baseCode = code,
        baseName = name;

  final String baseCode;
  final String baseName;
}

/// Returns a `Multibase` class based off a given code
Multibase getMultibaseFromCode(final String code) {
  for (final Multibase base in Multibase.values) {
    if (base.baseCode == code) {
      return base;
    }
  }
  throw Exception('Unknown base code: $code');
}

/// Encodes a given [suffixedMultihash] with a given multibase.
/// The encoded is the multibase code + encoded hash.
String encodeInputMultihashWithBase(final Multibase base, Uint8List suffixedMultihash) {
  switch (base) {
    case Multibase.base16:
      {
        String encodedHash = hex.encode(suffixedMultihash);
        return base.baseCode + encodedHash;
      }

    case Multibase.base16upper:
      {
        String encodedHash = hex.encode(suffixedMultihash);
        return base.baseCode + encodedHash.toUpperCase();
      }

    case Multibase.base32:
      {
        String encodedHash = base32Library.base32.encode(suffixedMultihash, encoding: Encoding.nonStandardRFC4648Lower);
        String padlessEncodedHash = encodedHash.replaceAll("=", "");

        return base.baseCode + padlessEncodedHash;
      }

    case Multibase.base32upper:
      {
        String encodedHash = base32Library.base32.encode(suffixedMultihash, encoding: Encoding.standardRFC4648);
        String padlessEncodedHash = encodedHash.replaceAll("=", "");

        return base.baseCode + padlessEncodedHash;
      }

    case Multibase.base58btc:
      {
        String encodedHash = base58.encode(suffixedMultihash);
        return base.baseCode + encodedHash;
      }

    case Multibase.base64:
      {
        String encodedHash = base64Encode(suffixedMultihash);
        return base.baseCode + encodedHash;
      }

    case Multibase.base64url:
      {
        String encodedHash = base64Encode(suffixedMultihash);
        return base.baseCode + encodedHash;
      }

    default:
      {
        throw UnsupportedError('Multibase spec base type not supported.');
      }
  }
}

/// Decodes a given string with a given multibase.
/// The input string should include the code of the multibase, do not splice it beforehand.
Uint8List decodeInputStringWithBase(final Multibase base, String input) {
  var sbstr = input.substring(1);

  switch (base) {
    case Multibase.base16:
      {
        return Uint8List.fromList(hex.decode(sbstr));
      }

    case Multibase.base16upper:
      {
        return Uint8List.fromList(hex.decode(sbstr));
      }

    case Multibase.base32:
      {
        return base32Library.base32.decode(sbstr, encoding: Encoding.nonStandardRFC4648Lower);
      }

    case Multibase.base32upper:
      {
        return base32Library.base32.decode(sbstr);
      }

    case Multibase.base58btc:
      {
        return base58.decode(sbstr);
      }

    case Multibase.base64:
      {
        return base64Decode(sbstr);
      }

    case Multibase.base64url:
      {
        return base64Decode(sbstr);
      }

    default:
      {
        throw UnsupportedError('Multibase spec base type not supported.');
      }
  }
}
