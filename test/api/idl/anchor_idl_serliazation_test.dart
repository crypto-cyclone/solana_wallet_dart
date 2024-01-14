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

    const String expectPlayAccount = "2wapp62tmGBbnZnpHsA3baK9KyoGvvTykhsZaZ7cruSMzDWZ3SZwLBi2Vna63AhDBKq7E4DhJR3J2MHo2EhknUg5dgKtQKCtm3Z1nTd1REXAoyKqN32DLErNMhDNK85V4kvJqjMiLX8zgphZbQZ81e2kxVxrLa7eiL4dxCsw6kjvwUSWqZADxoauvJQEvzvJ78pAVMkZqNEkSkxHLBF1po9CDprKcKFvy74GXNytZ8F8viDAAzBEuyVFmtTKoGVwMY8RBHRfL3KFTQQ5QN8JixYCczyrTLDszy83nQrKYAzBCcXyrcD4BueoxMw3YmgE1JfskwYdN5ZeNrt8ByrBbY7wC3YyHwPGGfCiWQgnKy6bgSchFkYsziPGKLRqxwsZB4xiPU4byhmsZrwGLjmfgYAws4trAVBLkGw9iCKvpWeJAxdhUScZvkox9f7SoaCU6dzbq3SiLxLokg2Xuobt1zsdHVxb1QcJFC1RTTNYs9gLwqsAXaQocx7RkrGDhnqUrJyqXsSHGUYesp2jaTbfmhhKHaaBKyXkeKsUdKghAAsEUCcWAdsu9Xa5o3hR9SPS4gRtA43cBXBZ6nX3GYSHwBbfDJuvMBxq8HUZsktnyUDms7zazsMgy7kXg5EEbKEUixYyYqpQtJhu4fL4f2EPQLfBCzRvAESJsDYNJomNhwPqvbxYrbt5mFsGrWxX";

    setUp(() async {
      _base58Encoder = Base58Encoder();

      _idl = HoneypotAnchorIDL()
        ..initialize();
    });

    test('deserialize player account', () async {
      var expectBytes = _base58Encoder.decodeBase58(expectPlayAccount);

      HoneypotPlayerAccount playerAccount = _idl.playerAccount.deserialize(
          expectBytes.toList());

      expect(
          playerAccount.name, "Player");

      expect(
          playerAccount.bumpField.value, 254);

      expect(
          _base58Encoder.encodeBase58(
              Uint8List.fromList(playerAccount.gameIdField.value.map((e) => e.value).toList())),
          "9Y8d99VrJKmD9QbXMKNiKrQ5xfEJPKkAtT1YGaEPDE7U");

      expect(
          playerAccount.lamportsField.value, 0);

      expect(
          playerAccount.lastSeenField.value, 1701019200);

      expect(
          playerAccount.stateField.value.index, 0);
    });
  });
}