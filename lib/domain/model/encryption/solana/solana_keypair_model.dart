import 'dart:typed_data';
import 'solana_extended_secret_key_model.dart';

class SolanaKeyPair {
  Uint8List publicKey;
  Uint8List privateKey;

  SolanaKeyPair(this.publicKey, this.privateKey);

  static SolanaKeyPair fromExtendedSecretKey(SolanaExtendedSecretKey extendedSecretKey) {
    return SolanaKeyPair(
      Uint8List.fromList(List.empty()),
      Uint8List.fromList(List.empty()),
    );
  }
}