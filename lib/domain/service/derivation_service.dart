import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/digests/sha512.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/pbkdf2.dart';
import 'package:pointycastle/macs/hmac.dart';
import 'package:solana_wallet/constants/mnemonic_words.dart';
import 'package:solana_wallet/domain/model/encryption/solana_derivation_path_model.dart';
import 'package:solana_wallet/util/byte_conversion.dart';
import '../model/encryption/solana_extended_secret_key_model.dart';

class DerivationService {

  List<String> encodeMnemonic(Uint8List seed) {
    int checksumBitsSize = seed.length ~/ 4;
    int entropyBitsSize = seed.length * 8;
    int checksumBytesSize = (checksumBitsSize / 8).ceil();

    Uint8List hash = _hashEntropy(seed);
    Uint8List checksumBytes = hash.sublist(0, checksumBytesSize);
    String checksumBits = checksumBytes.map((byte) => byte.toRadixString(2).padLeft(8, '0')).join('');
    String exactChecksumBits = checksumBits.substring(
      0, checksumBitsSize
    );

    String seedBits = seed.map((byte) => byte.toRadixString(2).padLeft(8, '0')).join('');
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

  Uint8List deriveSeed(List<String> mnemonic, [String passphrase = ""]) {
    String mnemonicStr = mnemonic.join(" ");
    String salt = "mnemonic$passphrase";

    final hmacSha512 = HMac(SHA512Digest(), 128);
    final derivator = PBKDF2KeyDerivator(hmacSha512);

    derivator.init(
      Pbkdf2Parameters(
        Uint8List.fromList(utf8.encode(salt)),
        2048,
        64,
      ),
    );

    return derivator.process(Uint8List.fromList(utf8.encode(mnemonicStr)));
  }

  SolanaExtendedSecretKey deriveMasterExtendSecretKey(Uint8List seed) {
    assert(seed.length == 64, 'Invalid seed length');

    final masterKey = Uint8List.fromList('ed25519 seed'.codeUnits);
    final mac = HMac(SHA512Digest(), 128);
    final keyParameter = KeyParameter(masterKey);
    mac.init(keyParameter);
    mac.update(seed, 0, seed.length);

    final output = Uint8List(mac.macSize);
    mac.doFinal(output, 0);

    final privateKey = output.sublist(0, 32);
    final chainCode = output.sublist(32, 64);

    return SolanaExtendedSecretKey(
      secretKey: privateKey,
      chainCode: chainCode,
    );
  }

  SolanaExtendedSecretKey deriveExtendedSecretKeyForPath(
      SolanaExtendedSecretKey masterKey,
      SolanaDerivationPath path) {

    var pathList = path.toList();

    if (pathList.isNotEmpty) {
      pathList.removeAt(0);
    }

    var next = masterKey;

    while (pathList.isNotEmpty) {
      var index = pathList.removeAt(0);

      final mac = HMac(SHA512Digest(), 128);
      final keyParameter = KeyParameter(next.chainCode);
      mac.init(keyParameter);
      mac.update(Uint8List.fromList([0]), 0, 0);
      mac.update(next.secretKey, 0, next.secretKey.length);

      // Solana uses hardened derivation
      final hardenedIndex = (1 << 31) | index;

      final indexBEBytes = toBEByteArray(hardenedIndex);
      mac.update(indexBEBytes, 0, indexBEBytes.length);

      final output = Uint8List(mac.macSize);
      mac.doFinal(output, 0);

      final derivedSecretKey = output.sublist(0, 32);
      final derivedChainCode = output.sublist(32, 64);

      next = SolanaExtendedSecretKey(
          depth: next.depth + 1,
          childIndex: index,
          secretKey: derivedSecretKey,
          chainCode: derivedChainCode
      );
    }

    return next;
  }

  Uint8List _hashEntropy(Uint8List entropy) {
    return Digest('SHA-256').process(entropy);
  }
}