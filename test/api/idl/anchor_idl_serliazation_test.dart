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
          "91MPefJ6fbYq3KoNsrikAJqgv1pftcx3WhoL4b1hS1H5"
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

      expect(
          playerAccount.stateField.value.index, 1);
    });
  });
}