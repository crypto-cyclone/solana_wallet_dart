import 'dart:typed_data';

import 'package:solana_wallet/domain/service/mnemonic_service.dart';

class SolanaMnemonic {
  late final List<String> mnemonic;
  late final Uint8List entropy;

  final MnemonicService _mnemonicService = MnemonicService();

  SolanaMnemonic.generate16() {
    entropy = _mnemonicService.generateEntropy16();
    mnemonic = _mnemonicService.encodeMnemonic(entropy);
  }

  SolanaMnemonic.generate20() {
    entropy = _mnemonicService.generateEntropy20();
    mnemonic = _mnemonicService.encodeMnemonic(entropy);
  }

  SolanaMnemonic.generate24() {
    entropy = _mnemonicService.generateEntropy24();
    mnemonic = _mnemonicService.encodeMnemonic(entropy);
  }

  SolanaMnemonic.generate28() {
    entropy = _mnemonicService.generateEntropy28();
    mnemonic = _mnemonicService.encodeMnemonic(entropy);
  }

  SolanaMnemonic.generate32() {
    entropy = _mnemonicService.generateEntropy32();
    mnemonic = _mnemonicService.encodeMnemonic(entropy);
  }

  SolanaMnemonic.withMnemonic(this.mnemonic) {
    if (mnemonic.isEmpty) {
      throw ArgumentError('Mnemonic must not be null or empty.');
    }

    if (mnemonic.length % 3 != 0 || mnemonic.length < 12 || mnemonic.length > 24) {
      throw ArgumentError('Mnemonic must be a list of 12, 15, 18, 21, or 24 words.');
    }

    entropy = _mnemonicService.decodeMnemonic(mnemonic);
  }

  SolanaMnemonic.withEntropy(this.entropy) {
    if (entropy.isEmpty) {
      throw ArgumentError('Entry must not be empty.');
    }

    if (entropy.length < 16 || entropy.length > 32 || entropy.length % 4 != 0) {
      throw ArgumentError('Entropy must be 16, 20, 24, 28, or 32 bytes.');
    }

    mnemonic = _mnemonicService.encodeMnemonic(entropy);
  }
}
