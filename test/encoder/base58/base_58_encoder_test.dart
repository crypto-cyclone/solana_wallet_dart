import 'dart:typed_data';

import 'package:hex/hex.dart';
import 'package:solana_wallet/encoder/base58/base_58_encoder.dart';
import 'package:test/test.dart';

void main() {
  group('Base58Encoder', () {
    test('encodeBase58', () {
      var hexKeys = [
        "86ad847f176d9f271f6e58ccf5017538b51849707ea4913ff0caaf895bae74d6",
        "0000000000000000000000000000000000000000000000000000000000000000",
        "0001f939b758f5",
        "13e7751b",
        "000e853cf7cd7e6a034bb1069f1a0596ea2c115e1351022c1acbb1aa48b05143fbe248ed9ab5825280017055c7a998c95a97948176add0b605a9b18fd77f6dd7202f6fc7fbe26273a319f7a9f5883dc62a641155a5",
        ""
      ];

      var expectedBase58Keys = [
        "A4j6JBMVTsB2MNNGhtym1fwM7c8TeNfn8MA9hDHvWKoB",
        "11111111111111111111111111111111",
        "1z12141z",
        "WWWWW",
        "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz",
        ""
      ];

      var base58 = Base58Encoder();

      for (var i = 0; i < hexKeys.length; i++) {
        var base58Key = base58.encodeBase58(
            Uint8List.fromList(HEX.decode(hexKeys[i]))
        );
        expect(base58Key, expectedBase58Keys[i]);
      }
    });

    test('decodeBase58', () {
      var base58Keys = [
        "A4j6JBMVTsB2MNNGhtym1fwM7c8TeNfn8MA9hDHvWKoB",
        "11111111111111111111111111111111",
        "1z12141z",
        "WWWWW",
        "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz",
        ""
      ];

      var expectedBytes = [
        "86ad847f176d9f271f6e58ccf5017538b51849707ea4913ff0caaf895bae74d6",
        "0000000000000000000000000000000000000000000000000000000000000000",
        "0001f939b758f5",
        "13e7751b",
        "000e853cf7cd7e6a034bb1069f1a0596ea2c115e1351022c1acbb1aa48b05143fbe248ed9ab5825280017055c7a998c95a97948176add0b605a9b18fd77f6dd7202f6fc7fbe26273a319f7a9f5883dc62a641155a5",
        ""
      ];

      var base58 = Base58Encoder();

      for (var i = 0; i < base58Keys.length; i++) {
        var base58Bytes = base58.decodeBase58(
            base58Keys[i]
        );

        expect(base58Bytes, Uint8List.fromList(HEX.decode(expectedBytes[i])));
      }
    });
  });
}