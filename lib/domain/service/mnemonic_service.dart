import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/api.dart';
import 'package:solana_wallet/constants/mnemonic_words.dart';

class MnemonicService {

  Uint8List generateEntropy16() {
    return _generateEntropy(16);
  }

  Uint8List generateEntropy20() {
    return _generateEntropy(20);
  }

  Uint8List generateEntropy24() {
    return _generateEntropy(24);
  }

  Uint8List generateEntropy28() {
    return _generateEntropy(28);
  }

  Uint8List generateEntropy32() {
    return _generateEntropy(32);
  }

  Uint8List _generateEntropy(int byteCount) {
    var rand = Random.secure();
    var bytes = Uint8List(byteCount);
    for (var i=0; i < byteCount; i++) {
      bytes[i] = rand.nextInt(256);
    }
    return bytes;
  }
  
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

  Uint8List decodeMnemonic(List<String> mnemonic) {
    List<String> mnemonicBitChunks = mnemonic.map((word) {
      int index = MNEMONIC_WORDS.indexOf(word);
      return index.toRadixString(2).padLeft(11, '0');
    }).toList();

    String mnemonicBits = mnemonicBitChunks.join('');

    int entropyBitsSize = (mnemonicBits.length / 33).floor() * 32;
    int checksumBitsSize = mnemonicBits.length - entropyBitsSize;

    String entropyBits = mnemonicBits.substring(0, entropyBitsSize);
    String exactChecksumBits = mnemonicBits.substring(entropyBitsSize);

    Uint8List entropy = Uint8List.fromList(
      Iterable<int>.generate(
        (entropyBits.length / 8).round(),
            (i) => int.parse(entropyBits.substring(i * 8, i * 8 + 8), radix: 2),
      ).toList(),
    );

    Uint8List hash = Digest('SHA-256').process(entropy);
    String checksumBits = hash
        .map((byte) => byte.toRadixString(2).padLeft(8, '0'))
        .join('')
        .substring(0, checksumBitsSize);

    if (checksumBits != exactChecksumBits) {
      throw Exception("Mnemonic words are invalid, or the checksum is incorrect");
    }

    return entropy;
  }
}