import 'dart:convert';
import 'dart:typed_data';

import '../../constants/base_58.dart';

class Base58 {
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
}