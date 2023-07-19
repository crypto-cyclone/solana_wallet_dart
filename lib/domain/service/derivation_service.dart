import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/digests/sha512.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/pbkdf2.dart';
import 'package:pointycastle/macs/hmac.dart';
import 'package:solana_wallet/util/byte_conversion.dart';

class DerivationService {

  Uint8List deriveSeed(List<String> phrase, [String passphrase = ""]) {
    String mnemonicStr = phrase.join(" ");
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

  MapEntry<Uint8List, Uint8List> deriveMasterExtendedSecretKey(Uint8List seed) {
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

    return MapEntry(privateKey, chainCode);
  }

  MapEntry<Uint8List, Uint8List> deriveChildExtendedSecretKey(
      Uint8List secretKey,
      Uint8List chainCode,
      List<int> pathList) {

    var nextSecretKey = secretKey;
    var nextChainCode = chainCode;

    while (pathList.isNotEmpty) {
      var index = pathList.removeAt(0);

      final mac = HMac(SHA512Digest(), 128);
      final keyParameter = KeyParameter(nextChainCode);
      mac.init(keyParameter);
      mac.update(Uint8List.fromList([0]), 0, 1);
      mac.update(nextSecretKey, 0, nextSecretKey.length);

      // Solana uses hardened derivation
      final hardenedIndex = (1 << 31) | index;

      final indexBEBytes = toBEByteArray(hardenedIndex);
      mac.update(indexBEBytes, 0, indexBEBytes.length);

      final output = Uint8List(mac.macSize);
      mac.doFinal(output, 0);

      final derivedSecretKey = output.sublist(0, 32);
      final derivedChainCode = output.sublist(32, 64);

      nextSecretKey = derivedSecretKey;
      nextChainCode = derivedChainCode;
    }

    return MapEntry(nextSecretKey, nextChainCode);
  }
}