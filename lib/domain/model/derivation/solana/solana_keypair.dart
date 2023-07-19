import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'solana_extended_secret_key.dart';

class SolanaKeyPair {
  final Uint8List publicKey;
  final Uint8List privateKey;

  SolanaKeyPair(this.publicKey, this.privateKey);

  static Future<SolanaKeyPair> fromSecretKey(Uint8List secretKey) async {
    final Ed25519 ed25519 = Ed25519();
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
    final Ed25519 ed25519 = Ed25519();
    return ed25519.newKeyPairFromSeed(privateKey.toList());
  }

  static Future<SolanaKeyPair> fromExtendedSecretKey(SolanaExtendedSecretKey extendedSecretKey) async {
    final Ed25519 ed25519 = Ed25519();
    SimpleKeyPair keyPair = await ed25519.newKeyPairFromSeed(
        extendedSecretKey.secretKey.toList()
    );

    return SolanaKeyPair(
      Uint8List.fromList((await keyPair.extractPublicKey()).bytes),
      Uint8List.fromList(await keyPair.extractPrivateKeyBytes()),
    );
  }
}