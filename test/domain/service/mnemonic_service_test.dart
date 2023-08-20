import 'dart:typed_data';

import 'package:hex/hex.dart';
import 'package:solana_wallet/domain/service/mnemonic_service.dart';
import 'package:test/test.dart';

void main() {
  group('MnemonicService', () {
    late MnemonicService mnemonicService;

    setUp(() {
      mnemonicService = MnemonicService();
    });

    test('generateEntropy16', () {
      var entropy = mnemonicService.generateEntropy16();

      expect(entropy.length, 16);
    });

    test('generateEntropy20', () {
      var entropy = mnemonicService.generateEntropy20();

      expect(entropy.length, 20);
    });

    test('generateEntropy24', () {
      var entropy = mnemonicService.generateEntropy24();

      expect(entropy.length, 24);
    });

    test('generateEntropy28', () {
      var entropy = mnemonicService.generateEntropy28();

      expect(entropy.length, 28);
    });

    test('generateEntropy32', () {
      var entropy = mnemonicService.generateEntropy32();

      expect(entropy.length, 32);
    });

    test('encodeMnemonic', () {
      var hexEntropy = "2e5a2fb1ecf80b8995b82a2801dc6d03";

      var expectedMnemonic = [
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

      var mnemonic = mnemonicService.encodeMnemonic(
          Uint8List.fromList(HEX.decode(hexEntropy))
      );

      expect(mnemonic, expectedMnemonic);
    });

    test('decodeMnemonic', () {
      var expectedEntropy = "2e5a2fb1ecf80b8995b82a2801dc6d03";

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

      var entropy = mnemonicService.decodeMnemonic(mnemonic);

      expect(HEX.encode(entropy), expectedEntropy);
    });
  });
}