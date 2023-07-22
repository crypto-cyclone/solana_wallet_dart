import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:solana_wallet/domain/service/derivation_service.dart';
import 'package:solana_wallet/encoder/base58/base_58_encoder.dart';

class SolanaKeyPair {
  late final Uint8List publicKey;
  late final Uint8List privateKey;

  final Ed25519 _ed25519 = Ed25519();
  final _base58 = Base58Encoder();

  String get publicKeyBase58 => _base58.encodeBase58(publicKey);

  SolanaKeyPair(this.publicKey, this.privateKey);

  static Future<SolanaKeyPair> derive(
      List<int> path,
      List<String> phrase,
      {String passphrase = ""}
  ) async {
    final derivationService = DerivationService();
    final Ed25519 ed25519 = Ed25519();

    var seed = derivationService.deriveSeed(phrase, passphrase);
    var masterKey = derivationService.deriveMasterExtendedSecretKey(seed);
    var derivedKey = derivationService.deriveChildExtendedSecretKey(
        masterKey.key,
        masterKey.value,
        path
    );

    var ed25519KeyPair = await ed25519.newKeyPairFromSeed(derivedKey.key);

    return SolanaKeyPair(
      Uint8List.fromList((await ed25519KeyPair.extractPublicKey()).bytes),
      Uint8List.fromList(await ed25519KeyPair.extractPrivateKeyBytes()),
    );
  }

  static Future<SolanaKeyPair> fromKeyPair(SimpleKeyPair keyPair) async {
    return SolanaKeyPair(
      Uint8List.fromList((await keyPair.extractPublicKey()).bytes),
      Uint8List.fromList(await keyPair.extractPrivateKeyBytes()),
    );
  }

  Future<SimpleKeyPair> toKeyPair() async {
    return _ed25519.newKeyPairFromSeed(privateKey.toList());
  }
}