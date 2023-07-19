import 'package:solana_wallet/domain/model/mnemonic/solana/solana_menmonic.dart';
import 'package:test/test.dart';

void main() {
  group('SolanaMnemonicTest', () {
    test('generateMnemonic16', () {
      var mnemonic = SolanaMnemonic.generate16();

      expect(mnemonic.mnemonic.length, 12);
      expect(mnemonic.entropy.length, 16);
    });

    test('generateMnemonic20', () {
      var mnemonic = SolanaMnemonic.generate20();

      expect(mnemonic.mnemonic.length, 15);
      expect(mnemonic.entropy.length, 20);
    });

    test('generateMnemonic24', () {
      var mnemonic = SolanaMnemonic.generate24();

      expect(mnemonic.mnemonic.length, 18);
      expect(mnemonic.entropy.length, 24);
    });

    test('generateMnemonic28', () {
      var mnemonic = SolanaMnemonic.generate28();

      expect(mnemonic.mnemonic.length, 21);
      expect(mnemonic.entropy.length, 28);
    });

    test('generateMnemonic32', () {
      var mnemonic = SolanaMnemonic.generate32();

      expect(mnemonic.mnemonic.length, 24);
      expect(mnemonic.entropy.length, 32);
    });
  });
}