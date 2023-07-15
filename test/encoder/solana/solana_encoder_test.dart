import 'package:flutter_test/flutter_test.dart';
import 'package:hex/hex.dart';
import 'package:solana_wallet/encoder/solana/solana_encoder.dart';

void main() {
  group('SolanaEncoder', () {
    test('encodeCompactArray', () {
      var expected1bytes = {
        0x0000: ["0"],
        0x0001: ["1"],
        0x007f: ["7f"],
      };

      var expected2bytes = {
        0x0080: ["80", "1"],
        0x3fff: ["ff", "7f"],
      };

      var expected3bytes = {
        0x4000: ["80", "80", "1"],
        0xc000: ["80", "80", "3"],
        0xffff: ["ff", "ff", "3"],
      };

      var encoder = SolanaEncoder();

      expected1bytes.forEach((key, value) {
        var encoded = encoder.encodeCompactArray(key);
        var expected = value
            .map((e) => HEX.decode(e))
            .reduce((value, element) => value + element);

        expect(encoded, expected);
      });

      expected2bytes.forEach((key, value) {
        var encoded = encoder.encodeCompactArray(key);
        var expected = value
            .map((e) => HEX.decode(e))
            .reduce((value, element) => value + element);

        expect(encoded, expected);
      });

      expected3bytes.forEach((key, value) {
        var encoded = encoder.encodeCompactArray(key);
        var expected = value
            .map((e) => HEX.decode(e))
            .reduce((value, element) => value + element);

        expect(encoded, expected);
      });
    });
  });
}