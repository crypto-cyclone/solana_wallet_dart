import 'dart:convert';
import 'dart:typed_data';
import 'package:solana_wallet/constants/base_58.dart';

class Base58Encoder {
  String encodeBase58(Uint8List bytes) {
    int maxEncodedSize = (((bytes.length * 352) + 255) / 256).ceil();
    Uint8List encoded = Uint8List(maxEncodedSize);

    int start = 0;
    while (start < bytes.length && bytes[start] == 0) {
      encoded[start] = base58AlphabetBytes[0];
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
      encoded[start++] = base58AlphabetBytes[encoded[i]];
    }

    return utf8.decode(encoded.sublist(0, start));
  }

  Uint8List decodeBase58(String input) {
    BigInt intData = BigInt.from(0);
    for (int i = 0; i < input.length; i++) {
      intData = intData * BigInt.from(58);
      intData = intData + BigInt.from(base58Alphabet.indexOf(input[i]));
    }

    List<int> bytes = [];
    while (intData > BigInt.from(0)) {
      bytes.insert(0, (intData & BigInt.from(0xFF)).toInt());
      intData = intData >> 8;
    }

    for (int i = 0; i < input.length && input[i] == base58Alphabet[0]; i++) {
      bytes.insert(0, 0);
    }

    return Uint8List.fromList(bytes);
  }
}