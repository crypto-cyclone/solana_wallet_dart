import 'dart:typed_data';

class SolanaEncoder {
  Uint8List encodeCompactArray(int number) {
    const firstByteThreshold = 0x7f;
    const secondByteThreshold = 0x3fff;

    String binaryString = number.toRadixString(2).padLeft(16, '0');
    binaryString = binaryString.substring(binaryString.length - 16);

    List<String> byteStrings;
    if (number > secondByteThreshold) {
      byteStrings = [
        "1${binaryString.substring(9, 16)}",
        "1${binaryString.substring(2, 9)}",
        "0${binaryString.substring(0, 2)}",
      ];
    } else if (number > firstByteThreshold) {
      byteStrings = [
        "1${binaryString.substring(9, 16)}",
        "0${binaryString.substring(2, 9)}",
      ];
    } else {
      byteStrings = [
        "0${binaryString.substring(9, 16)}",
      ];
    }

    return Uint8List.fromList(byteStrings.map(binaryToByte).toList());
  }

  int binaryToByte(String binaryString) {
    return int.parse(binaryString, radix: 2);
  }
}