import 'dart:typed_data';

class SolanaKeyPair {
  Uint8List publicKey;
  Uint8List privateKey;

  SolanaKeyPair(this.publicKey, this.privateKey);
}