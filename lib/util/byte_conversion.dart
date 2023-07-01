import 'dart:typed_data';

Uint8List toBEByteArray(int value) {
  final buffer = Uint8List(4);
  final view = ByteData.view(buffer.buffer);
  view.setUint32(0, value, Endian.big);
  return buffer;
}

Uint8List toLEByteArray(int value, int byteSize) {
  final buffer = Uint8List(byteSize);
  final view = ByteData.view(buffer.buffer);
  view.setUint64(0, value, Endian.little);
  return buffer;
}