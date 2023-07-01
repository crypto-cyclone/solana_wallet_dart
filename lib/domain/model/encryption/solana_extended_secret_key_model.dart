import 'dart:typed_data';

class SolanaExtendedSecretKey {
  Uint8List secretKey; // 32 bytes
  Uint8List chainCode; // 32 bytes
  int depth;
  int childIndex;

  SolanaExtendedSecretKey({
    required this.secretKey,
    required this.chainCode,
    this.depth = 0,
    this.childIndex = 0,
  });
}