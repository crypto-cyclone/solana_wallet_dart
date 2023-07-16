import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'solana_extended_secret_key_model.dart';

class SolanaKeyPair {
  Uint8List publicKey;
  Uint8List privateKey;

  SolanaKeyPair(this.publicKey, this.privateKey);

  static Future<SolanaKeyPair> fromSecretKey(Uint8List secretKey) async {
    var ed25519 = Ed25519();
    SimpleKeyPair keyPair = await ed25519.newKeyPairFromSeed(
        secretKey.toList()
    );
    SimplePublicKey publicKey = await keyPair.extractPublicKey();

    return SolanaKeyPair(
      Uint8List.fromList(publicKey.bytes),
      Uint8List.fromList(await keyPair.extractPrivateKeyBytes()),
    );
  }

  Future<SimpleKeyPair> toKeyPair() async {
    var ed25519 = Ed25519();
    return ed25519.newKeyPairFromSeed(privateKey.toList());
  }

  static SolanaKeyPair fromExtendedSecretKey(SolanaExtendedSecretKey extendedSecretKey) {
    return SolanaKeyPair(
      Uint8List.fromList(List.empty()),
      Uint8List.fromList(List.empty()),
    );
  }
}