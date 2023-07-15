import 'dart:convert';
import 'dart:typed_data';
import '../../constants/base_58.dart';

class Base58Encoder {
  String encodeBase58(Uint8List bytes) {
    int maxEncodedSize = (((bytes.length * 352) + 255) / 256).ceil();
    Uint8List encoded = Uint8List(maxEncodedSize);

    int start = 0;
    while (start < bytes.length && bytes[start] == 0) {
      encoded[start] = BASE58_ALPHABET[0];
      start++;
    }

    int pos = maxEncodedSize - 1;
    for (int i = start; i < bytes.length; i++) {
      int carry = bytes[i];
      int j = maxEncodedSize - 1;
      while(carry != 0 || j > pos) {
        carry += encoded[j] * 256;
        encoded[j] = (carry % 58);
        carry ~/= 58;
        j--;
      }
      pos = j;
    }

    for (int i = (pos + 1); i < maxEncodedSize; i++) {
      encoded[start++] = BASE58_ALPHABET[encoded[i]];
    }

    return utf8.decode(encoded.sublist(0, start));
  }

  Uint8List decodeBase58(String base58) {
    int maxDecodedSize = base58.length;
    Uint8List decoded = Uint8List(maxDecodedSize);

    Uint8List bytes = Uint8List(base58.length);
    for (int i = 0; i < base58.length; i++) {
      int c = base58.codeUnitAt(i);
      int b = (c <= BASE58_ALPHABET_ASCII_LOOKUP.length) ? BASE58_ALPHABET_ASCII_LOOKUP[c] : -1;
      if (b == -1) {
        throw FormatException("Character '$c' at [$i] is not a valid base58 character");
      }
      bytes[i] = b;
    }

    int start = 0;
    while (start < bytes.length && bytes[start] == 0) {
      start++;
    }
    int zeroes = start;

    int pos = bytes.length - 1;
    while (start < bytes.length) {
      if (bytes[start] == 0) {
        start++;
      } else {
        int mod = 0;
        for (int i = start; i < bytes.length; i++) {
          mod = mod * 58 + bytes[i];
          bytes[i] = (mod ~/ 256);
          mod %= 256;
        }
        decoded[pos--] = mod;
      }
    }

    Uint8List result = Uint8List(zeroes + bytes.length - pos - 1);
    result.setRange(zeroes, bytes.length - pos - 1, decoded, pos + 1);
    return result;
  }
}