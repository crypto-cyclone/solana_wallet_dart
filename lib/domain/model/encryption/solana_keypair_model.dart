import 'dart:typed_data';

import 'package:solana_wallet/domain/model/encryption/solana_extended_secret_key_model.dart';
import 'package:solana_wallet/encoder/base58/base_58_encoder.dart';

class SolanaKeyPair {
  Uint8List publicKey;
  Uint8List privateKey;

  SolanaKeyPair(this.publicKey, this.privateKey);

  base58EncodedPublicKey() {
    return Base58().encodeBase58(publicKey);
  }

  static SolanaKeyPair fromExtendedSecretKey(SolanaExtendedSecretKey extendedSecretKey) {
    return SolanaKeyPair(
      Uint8List.fromList(List.empty()),
      Uint8List.fromList(List.empty()),
    );
  }
}