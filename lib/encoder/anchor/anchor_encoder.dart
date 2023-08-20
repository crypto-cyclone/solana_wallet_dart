import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/digests/sha256.dart';

class AnchorEncoder {
  Uint8List encodeDiscriminator(String namespace, String accountName) {
    String discriminatorPreimage = namespace.isEmpty
        ? 'account:$accountName'
        : '$namespace:$accountName';

    var bytes = utf8.encode(discriminatorPreimage);
    var sha256Digest = SHA256Digest();
    var digest = sha256Digest.process(Uint8List.fromList(bytes));

    return Uint8List.fromList(digest.sublist(0, 8));
  }
}