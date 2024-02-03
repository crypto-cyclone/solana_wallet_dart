import 'dart:convert';
import 'dart:typed_data';

import 'package:solana_wallet/encoder/base58/base_58_encoder.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'mocks/honeypot.dart';

void main() {
  group('AnchorIDL', () {
    late Base58Encoder _base58Encoder;

    late HoneypotAnchorIDL _idl;

    const String expectPlayAccount = "zd5wB6Wbztq3tNogHsfF/PlNtHG0m4XnFT6aNwRMk+59jiDuk3yggf2INOvWAyDof3tELiFu5yYNXKFGkWupaBfxFwEVh9T7I1qDEAaps3BALG83AQAAAPwLHKxlAAAAAAF29I0QOVKo6Rixqg9w57AmqdeZvIvmcRe5rWxcebtXDAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

    const String expectEngageAccount = "ABu7fcPb69v/bVG9ZQAAAAADAYtArbkQgCRjSwJTTlpGSnnXUlVgy2NqESzDctmf4NvqR3x8wK7HNKA2sgoHFmxYtd+cv4sfiRktTACHUjNMLP8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKrNWl/VwkoU7h+VlMfthA3QaBvKOEJBJUufpz16F44YAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

    setUp(() async {
      _base58Encoder = Base58Encoder();

      _idl = HoneypotAnchorIDL()
        ..initialize();
    });

    test('deserialize player account', () async {
      var expectBytes = base64.decode(expectPlayAccount);

      HoneypotPlayerAccount playerAccount = _idl.playerAccount.deserialize(
          expectBytes.toList());

      expect(
          playerAccount.name, "Player");

      expect(
          _base58Encoder.encodeBase58(
              playerAccount.engageAccountField.value),
          "6icWwUemWbjGzsCjcoecssSeeVsyZMrCKyauYcDZqhg"
      );

      expect(
          playerAccount.bumpField.value, 252);

      expect(
          _base58Encoder.encodeBase58(
              Uint8List.fromList(playerAccount.gameIdField.value.map((e) => e.value).toList())),
          "9ado7KVoRnYPua2HabFnTjHxF4tRoPH2UV4nMypUrsMh");

      expect(
          playerAccount.lamportsField.value, 5225000000);

      expect(
          playerAccount.lastSeenField.value, 1705778187);
    });

    test('deserialize engage account', () async {
      var expectBytes = base64.decode(expectEngageAccount);

      HoneypotEngageAccount engageAccount = _idl.engageAccount.deserialize(
          expectBytes.toList());

      expect(
          engageAccount.name, "Engage");

      expect(
          engageAccount.bumpField.value, 255);

      expect(
          engageAccount.timestampField.value, 1706905965);

      expect(
          engageAccount.roundCountField.value, 3);

      expect(
          engageAccount.statusField.value, HoneypotEngageStatusEnum.READY);

      expect(
          _base58Encoder.encodeBase58(
            engageAccount.challengerField.value), "ANasafJr5ZLwYuwfvaLMp3Qt2juTCzADwDwUqDEHGeho");

      expect(
          _base58Encoder.encodeBase58(
              engageAccount.defenderField.value), "5p43YBrTBHAhQTMEKHzAoAHmo8zy1nGJieJVhq8MnyR8");

      expect(
          _base58Encoder.encodeBase58(
              Uint8List.fromList(
                  engageAccount.challengerSealedMoveField.value.hashedMoveField.value.map((e) => e.value)
                      .toList())),
          "11111111111111111111111111111111");

      expect(
          _base58Encoder.encodeBase58(
              Uint8List.fromList(
                  engageAccount.defenderSealedMoveField.value.hashedMoveField.value.map((e) => e.value)
                      .toList())),
          "CVjvavDKF9w7bCYn9GF98HWzKnTt4y96hkZaJnNsL3XD");

      expect(
          engageAccount.challengerMovesField.value.every((e) => e.value == HoneypotMoveTypeEnum.NONE), true);

      expect(
          engageAccount.defenderMovesField.value.every((e) => e.value == HoneypotMoveTypeEnum.NONE), true);

      expect(
          engageAccount.resultsField.value.every((e) => e.value == HoneypotEngageResultEnum.NONE), true);

    });
  });
}