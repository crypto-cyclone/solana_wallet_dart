import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';

Uint8List toBEByteArray(int value) {
  final buffer = Uint8List(4);
  final view = ByteData.view(buffer.buffer);
  view.setUint32(0, value, Endian.big);
  return buffer;
}

Uint8List toLEByteArray(int value, int byteSize) {
  final buffer = Uint8List(byteSize);
  final view = ByteData.view(buffer.buffer);
  final intValue = Int64(value);

  if (byteSize == 8) {
    for (int i = 0; i < 8; i++) {
      int byteValue = ((intValue >> (i * 8)) & 0xff).toInt();
      view.setUint8(i, byteValue);
    }
  } else if (byteSize == 4) {
    view.setUint32(0, value, Endian.little);
  } else {
    throw Exception('Unsupported byteSize: $byteSize. Supported sizes are 4 and 8.');
  }

  return buffer;
}

Uint8List toBEByteArrayBigInt(BigInt value) {
  var hexStr = value.toRadixString(16).padLeft(16, '0');
  var asBytes = Uint8List.fromList(List<int>.generate(8, (index) {
    return int.parse(hexStr.substring(index*2, (index*2)+2), radix: 16);
  }));
  return asBytes.buffer.asUint8List();
}

Uint8List toLEByteArrayBigInt(BigInt value, int byteSize) {
  var hexStr = value.toRadixString(16).padLeft(byteSize * 2, '0');
  var asBytes = Uint8List.fromList(List<int>.generate(byteSize, (index) {
    return int.parse(hexStr.substring((byteSize - index - 1)*2, ((byteSize - index - 1)*2)+2), radix: 16);
  }));
  return asBytes.buffer.asUint8List();
}
