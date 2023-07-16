import 'dart:typed_data';

class SolanaEncoder {
  Uint8List encodeCompactArray(int number) {
    const firstByteThreshold = 0x7f;
    const secondByteThreshold = 0x3fff;

    List<int> bytes = [];
    if (number > secondByteThreshold) {
      bytes = [
        0x80 | (number & 0x7F),
        0x80 | ((number >> 7) & 0x7F),
        (number >> 14) & 0x03,
      ];
    } else if (number > firstByteThreshold) {
      bytes = [
        0x80 | (number & 0x7F),
        (number >> 7) & 0x7F,
      ];
    } else {
      bytes = [number & 0x7F];
    }

    return Uint8List.fromList(bytes);
  }
}