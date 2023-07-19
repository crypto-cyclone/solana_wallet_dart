import 'package:hex/hex.dart';
import 'package:solana_wallet/domain/model/derivation/solana/solana_derivation_path.dart';
import 'package:solana_wallet/domain/model/derivation/solana/solana_keypair.dart';
import 'package:test/test.dart';

void main() {
  group('SolanaDerivationTest', () {
    test('DeriveSolanaKeyPair', () async {
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

      var derivationPath = SolanaDerivationPath(account: 63);
      var path = derivationPath.toList();

      expect(path, [44, 501, 63]);

      SolanaKeyPair keyPair = await SolanaKeyPair.derive(path, mnemonic);

      expect(
          keyPair.publicKey.toList(),
          HEX.decode("9ee83ce335b62bebe12d6dff76da1d3a87b2e720afbb659db8be7c4546d059a9")
      );
    });
  });
}