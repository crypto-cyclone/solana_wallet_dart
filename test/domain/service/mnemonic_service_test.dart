import 'dart:typed_data';

import 'package:hex/hex.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solana_wallet/domain/service/mnemonic_service.dart';

void main() {
  group('MnemonicService', () {
    late MnemonicService mnemonicService;

    setUp(() {
      mnemonicService = MnemonicService();
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

      var entropy = mnemonicService.encodeMnemonic(
          Uint8List.fromList(HEX.decode(hexEntropy))
      );

      expect(entropy, expected);
    });
  });
}