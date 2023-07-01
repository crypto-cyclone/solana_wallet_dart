import 'dart:typed_data';

import 'package:hex/hex.dart';
import 'package:solana_wallet/domain/service/derivation_service.dart';
import 'package:test/test.dart';

void main() {
  group('DerivationService', () {
    late DerivationService derivationService;

    setUp(() {
      derivationService = DerivationService();
    });

    test('encodeMnemonic', () {
      var hexEntropy = "2e5a2fb1ecf80b8995b82a2801dc6d03";

      var expected = [
        "comic",
        "sphere",
        "unaware",
        "supreme",
        "level",
        "shadow",
        "finger",
        "aim",
        "chimney",
        "auction",
        "brave",
        "alter"
      ];

      var entropy = derivationService.encodeMnemonic(
          Uint8List.fromList(HEX.decode(hexEntropy))
      );

      expect(entropy, expected);
    });

    test('generateDerivationSeed', () {
      var hexSeed = "5f0a5d2213ae6ca550494c9bb96e6711fe9dd722bb79293e3c700c309aaa11285176cedad042b80dc1db570c46e7a08bc5b378308349ae1aeb444cb610eec2fa";
      var expected = Uint8List.fromList(HEX.decode(hexSeed));

      var mnemonic = [
        "comic",
        "sphere",
        "unaware",
        "supreme",
        "level",
        "shadow",
        "finger",
        "aim",
        "chimney",
        "auction",
        "brave",
        "alter"
      ];

      var derivedSeed = derivationService.deriveSeed(mnemonic);

      expect(derivedSeed.lengthInBytes, 64);
      expect(derivedSeed.toList(), expected.toList());
    });

    // Add more tests if needed...
  });
}