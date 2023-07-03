import 'dart:typed_data';

class Ed25519Keypair {
  Uint8List privateKey;
  Uint8List publicKey;

  Ed25519Keypair(this.privateKey, this.publicKey);

  bool isValid() {
    return privateKey.length == 64 && publicKey.length == 32;
  }
}