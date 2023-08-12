import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:pointycastle/api.dart';
import 'package:solana_wallet/encoder/base58/base_58_encoder.dart';

class PDAService {
  final Base58Encoder _base58Encoder = Base58Encoder();
  final Ed25519 _ed25519 = Ed25519();

  Future<MapEntry<Uint8List, int>> findProgramAddress(List<Uint8List> seeds, String programId) async {
    var nonce = 255;
    late Uint8List address;

    while (nonce != 0) {
      try {
        final seedsWithNonce = List<Uint8List>.from(seeds)
          ..add(Uint8List.fromList([nonce & 0xFF]));
        address = await _createProgramAddress(seedsWithNonce, programId);
      } catch (e) {
        nonce--;
        continue;
      }

      return MapEntry(address, nonce);
    }

    throw StateError("Unable to find a viable program address nonce");
  }

  Future<Uint8List> _createProgramAddress(List<Uint8List> seeds, String programId) async {
    var programIdBytes = _base58Encoder.decodeBase58(programId);
    var programDerivedAddressLiteral = utf8.encode("ProgramDerivedAddress");

    var seedsSize = seeds.fold<int>(0, (acc, bytes) => acc + bytes.length);

    var maxSeedLength = 32;
    var buffer = ByteData(seedsSize + programIdBytes.length + programDerivedAddressLiteral.length);

    int offset = 0;
    for (var seed in seeds) {
      if (seed.length > maxSeedLength) {
        throw Exception("Max seed length exceeded");
      }
      buffer.buffer.asUint8List().setRange(offset, offset + seed.length, seed);
      offset += seed.length;
    }

    buffer.buffer.asUint8List().setRange(offset, offset + programIdBytes.length, programIdBytes);
    offset += programIdBytes.length;

    buffer.buffer.asUint8List().setRange(offset, offset + programDerivedAddressLiteral.length,
        programDerivedAddressLiteral);

    var sha256 = Digest('SHA-256');
    var publicKeyBytes = sha256.process(buffer.buffer.asUint8List());

    if (await _ed25519.verifyPublicKeyBytes(publicKeyBytes)) {
        throw Exception("Invalid seeds, address must fall off the curve");
    }

    return publicKeyBytes;
  }
}