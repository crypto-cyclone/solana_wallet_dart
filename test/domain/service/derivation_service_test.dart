import 'dart:typed_data';

import 'package:hex/hex.dart';
import 'package:solana_wallet/domain/model/encryption/solana_derivation_path_model.dart';
import 'package:solana_wallet/domain/model/encryption/solana_extended_secret_key_model.dart';
import 'package:solana_wallet/domain/model/encryption/solana_keypair_model.dart';
import 'package:solana_wallet/domain/service/derivation_service.dart';
import 'package:test/test.dart';

void main() {
  group('DerivationService', () {
    late DerivationService derivationService;

    setUp(() {
      derivationService = DerivationService();
    });

    test('deriveSeed', () {
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

    test('deriveMasterExtendedSecretKey', () {
      var seed = "5f0a5d2213ae6ca550494c9bb96e6711fe9dd722bb79293e3c700c309aaa11285176cedad042b80dc1db570c46e7a08bc5b378308349ae1aeb444cb610eec2fa";
      var secretKey = "448d941059eaa2e6ea0cba639b1ae64df42757fa47777879280f0bcf24bda383";
      var chainCode = "1d4c20be1b0e62c2c279675f79969b6a1960d6cacd4c09a3b0b6e993124c424d";

      var masterExtendedKey = derivationService.deriveMasterExtendSecretKey(
          Uint8List.fromList(HEX.decode(seed))
      );

      expect(masterExtendedKey.secretKey.toList(), HEX.decode(secretKey));
      expect(masterExtendedKey.chainCode.toList(), HEX.decode(chainCode));
    });

    test('deriveExtendedSecretKeyForPath', () {
      var masterExtendedSecretKey = SolanaExtendedSecretKey(
          secretKey: Uint8List.fromList(HEX.decode("448d941059eaa2e6ea0cba639b1ae64df42757fa47777879280f0bcf24bda383")),
          chainCode: Uint8List.fromList(HEX.decode("1d4c20be1b0e62c2c279675f79969b6a1960d6cacd4c09a3b0b6e993124c424d"))
      );

      var extendedSecretKey = derivationService.deriveExtendedSecretKeyForPath(
          masterExtendedSecretKey,
          SolanaDerivationPath.fromPath("44'/501'/0'")
      );

      expect(
          extendedSecretKey.secretKey.toList(),
          HEX.decode("5db45bb29ad9d4e7becacdeaed09e616a4e95c84927dca0f978335112e20625d")
      );
    });
  });
}