import 'dart:convert';
import 'dart:typed_data';

import 'package:solana_wallet/domain/service/pda_service.dart';
import 'package:solana_wallet/encoder/anchor/anchor_encoder.dart';
import 'package:solana_wallet/encoder/base58/base_58_encoder.dart';
import 'package:solana_wallet/encoder/solana/solana_encoder.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'mocks/honeypot.dart';

void main() {
  group('AnchorIDL', () {
    late Base58Encoder _base58Encoder;

    late HoneypotAnchorIDL _idl;

    const String expectPlayAccount = "zd5wB6WbztonXb3YQrmNSOGK3GZLKH5CDUvlTS0YrGNthKv1jCw2lcCVqQUAAAAA+hgMp2UAAAAAAbddIsBy8jpTyJjNo5IjVKAMUecROcwNxmM5ajQ9Wb/CAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

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
          "DLmykQGZCraaPVHXnRwpW3GfUf6mPGCXuFzjEmj6y9fw"
      );

      expect(
          playerAccount.bumpField.value, 250);

      expect(
          _base58Encoder.encodeBase58(
              Uint8List.fromList(playerAccount.gameIdField.value.map((e) => e.value).toList())),
          "3efojWyvcB8nb1bt19G1wEcyjZrFwGTWC59bx4tNcFtg");

      expect(
          playerAccount.lamportsField.value, 95000000);

      expect(
          playerAccount.lastSeenField.value, 1705446424);

      expect(
          playerAccount.stateField.value.index, 1);
    });
  });
}