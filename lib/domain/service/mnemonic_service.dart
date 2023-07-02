import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/api.dart';
import '../../constants/mnemonic_words.dart';

class MnemonicService {
  List<String> encodeMnemonic(Uint8List entropy) {
    int checksumBitsSize = entropy.length ~/ 4;
    int entropyBitsSize = entropy.length * 8;
    int checksumBytesSize = (checksumBitsSize / 8).ceil();

    Uint8List hash = Digest('SHA-256').process(entropy);
    Uint8List checksumBytes = hash.sublist(0, checksumBytesSize);
    String checksumBits = checksumBytes.map((byte) => byte.toRadixString(2).padLeft(8, '0')).join('');
    String exactChecksumBits = checksumBits.substring(
        0, checksumBitsSize
    );

    String seedBits = entropy.map((byte) => byte.toRadixString(2).padLeft(8, '0')).join('');
    String mnemonicBits = seedBits + exactChecksumBits;

    if (mnemonicBits.length != entropyBitsSize + checksumBitsSize) {
      return List.empty();
    }

    List<String> mnemonicBitChunks = [];
    for (int i = 0; i < mnemonicBits.length; i += 11) {
      int endIndex = min(i + 11, mnemonicBits.length);
      mnemonicBitChunks.add(mnemonicBits.substring(i, endIndex));
    }

    return mnemonicBitChunks.map((chunk) {
      int index = int.parse(chunk, radix: 2);
      return MNEMONIC_WORDS[index];
    }).toList();
  }
}