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

  switch (byteSize) {
    case 8:
      for (int i = 0; i < 8; i++) {
        int byteValue = ((intValue >> (i * 8)) & 0xff).toInt();
        view.setUint8(i, byteValue);
      }
      break;
    case 4:
      view.setInt32(0, value, Endian.little);
      break;
    case 2:
      view.setInt16(0, value, Endian.little);
      break;
    case 1:
      view.setInt8(0, value);
      break;
    default:
      throw Exception('Unsupported byteSize: $byteSize. Supported sizes are 1, 2, 4, and 8.');
  }

  return buffer;
}

int fromLEByteArray(Uint8List bytes) {
  final view = ByteData.view(bytes.buffer);

  switch (bytes.length) {
    case 8:
      int value = 0;
      for (int i = 0; i < 8; i++) {
        value |= (view.getUint8(i) & 0xff) << (i * 8);
      }
      return value;
    case 4:
      return view.getInt32(0, Endian.little);
    case 2:
      return view.getInt16(0, Endian.little);
    case 1:
      return view.getUint8(0);
    default:
      throw Exception('Unsupported byte length: ${bytes.length}. Supported lengths are 1, 2, 4, and 8.');
  }
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
