import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:solana_wallet/domain/service/pda_service.dart';
import 'package:solana_wallet/encoder/base58/base_58_encoder.dart';

void main() {
  group('PDAService', () {
    late PDAService pdaService;
    late Base58Encoder base58Encoder;

    setUp(() {
      pdaService = PDAService();
      base58Encoder = Base58Encoder();
    });

    test('find meta plex pda', () async {
      var metaDataSeed = "metadata";
      var programId = "metaqbxxUerdq28cj1RbAWkYQm3ybzjb6a8bt518x1s";
      var mintAddress = "4siT7XaV5xz6d1ArAy4ma8SkNRUhsrCQxjw9BpB8PfTK";

      var seeds = [
        Uint8List.fromList(utf8.encode(metaDataSeed)),
        base58Encoder.decodeBase58(programId),
        base58Encoder.decodeBase58(mintAddress)
      ];

      var pda = await pdaService.findProgramAddress(seeds, programId);

      expect(base58Encoder.encodeBase58(pda.key), "FWxGAqf4SRnThuio5DFpKArAD4vS75XDj1j3vxL8GJWr");
      expect(pda.value, 255);
    });

    test('find map account pda', () async {
      var mapSeed = "map_account";
      var makerAccount = "12cirEnr2G8TVHSbyzx99Kof7Y6GY8EQpEaamaEmq2Rv";
      var programId = "8WdhLFkpr5sudFiCP1WknJvxVRagsUV6ohmKXuNBMZwG";

      var seeds = [
        Uint8List.fromList(utf8.encode(mapSeed)),
        base58Encoder.decodeBase58(makerAccount)
      ];

      var pda = await pdaService.findProgramAddress(seeds, programId);

      expect(base58Encoder.encodeBase58(pda.key), "6YqncPjUB58x3ftCiJUkUfyc9aDNQdEFRmLeabLXbP9i");
      expect(pda.value, 251);
    });
  });
}