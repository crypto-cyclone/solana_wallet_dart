import 'dart:convert';
import 'dart:typed_data';

import 'package:solana_wallet/constants/solana/program_library.dart';
import 'package:solana_wallet/domain/model/derivation/solana/solana_keypair.dart';
import 'package:solana_wallet/domain/model/transaction/anchor/anchor_instruction_data.dart';
import 'package:solana_wallet/domain/service/pda_service.dart';
import 'package:solana_wallet/encoder/anchor/anchor_encoder.dart';
import 'package:solana_wallet/encoder/base58/base_58_encoder.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'mocks/sol_raider.dart';

void main() {
  group('AnchorIDL', () {
    late Base58Encoder _base58Encoder;
    late AnchorEncoder _anchorEncoder;
    late PDAService _pdaService;

    late SolRaiderAnchorIDL _idl;

    setUp(() async {
      _base58Encoder = Base58Encoder();
      _anchorEncoder = AnchorEncoder();
      _pdaService = PDAService();

      _idl = SolRaiderAnchorIDL()..initialize();
    });

    test('anchorInstructionToTransaction1', () async {
      var blockhash = "563MEMYqt2tQuaAM6aWwcfgsNdopaetuqABoEAiVnsAk";
      var programId = _idl.metadata.address;

      var map25x25 = SolanaKeyPair(
          _base58Encoder.decodeBase58("8R2PWkbC1Btt6SP15TQagSg4eCsNkCRrAqLhpN7ZgSpM"),
          Uint8List.fromList(
              _base58Encoder.decodeBase58(
                  "466AVjzWRLScurWJNvBzPGMG4rfMhZn1XWF3oru5KP6XUN2LcKB2R6mhncpKh3C4REPGWs19qy4gf6gEF6A3aE9B"
              ).take(32).toList()
          )
      );


      var mapAccount25x25 = (
          await _pdaService.findProgramAddress([
            Uint8List.fromList(utf8.encode("map_account")),
            map25x25.publicKey
          ], programId)).key;

      var transaction25x25 = await SolRaiderCreateMapInstruction()
          .withArgs("map25x25", 25)
          .withAccounts(
            _base58Encoder.encodeBase58(mapAccount25x25),
            _base58Encoder.encodeBase58(map25x25.publicKey),
            systemProgram)
          .toTransaction(programId, blockhash)
          .signTransaction([await map25x25.toKeyPair()]);

      expect(transaction25x25.noSignatures, 1);
      expect(transaction25x25.message.header.noSigs, 1);
      expect(transaction25x25.message.header.noSignedReadOnlyAccounts, 0);
      expect(transaction25x25.message.header.noUnsignedReadOnlyAccounts, 2);
      expect(transaction25x25.message.instructions.length, 1);
      expect(transaction25x25.message.instructions[0].programIdIndex, 3);
      expect(transaction25x25.message.instructions[0].accountIndices, Uint8List.fromList([1, 0, 2]));

      AnchorInstructionData instructionData25x25 = transaction25x25.message.instructions[0].data as AnchorInstructionData;

      expect(instructionData25x25.discriminator, _anchorEncoder.encodeDiscriminator("global", "create_map"));

      expect(
          _base58Encoder.encodeBase58(transaction25x25.serialize()),
          "TewrfVfLMYaJJ9TH7F3tykgdh5opBbFkZUccC2SVCSkHExULc6Tj6yDD1XtRNBEHRYGytrn4fpz2AH2XZFtcucwuVVtN93fSYUKgGspC3XDkWexeFuxuYqSjYvunifrek2JDM4JcadtZBLZrYY2eE2PZjGiVKDQk5r6aYXY42HuRnudjrVrFFz6RBDyvJambCao1iWy9p4MDmyAtzvvPdj1KRQ2eie9uVWMvM3khURNNR1DatbwV4hksYopw5jDegarphcKhKWPwoW6kwk7gWZcYS74ZoVeZdHavdQsiFyN577XnqJW8kaYRHgyyKQWdLbiWRTfjzDku9nX7Zg4yM2ZTemuWqJqXNw"
      );
    });

    test('anchorInstructionToTransaction2', () async {
      var blockhash = "563MEMYqt2tQuaAM6aWwcfgsNdopaetuqABoEAiVnsAk";
      var programId = _idl.metadata.address;

      var map50x50 = SolanaKeyPair(
          _base58Encoder.decodeBase58("MKoiM8Qa85AAEqxJsyECE1LTxrhE3wEH6Sdhwm7N66c"),
          Uint8List.fromList(
              _base58Encoder.decodeBase58(
                  "5oi3jdHedJjBR3SYKJAmfLArnXcjctAZRwrtCJaYopSKLu7TLMyb3ue2iTJ65KgebBwvNMNfWdSx6vJPL6UnXXKv"
              ).take(32).toList()
          )
      );

      var mapAccount50x50 = (
          await _pdaService.findProgramAddress([
            Uint8List.fromList(utf8.encode("map_account")),
            map50x50.publicKey
          ], programId)).key;

      var transaction50x50 = await SolRaiderCreateMapInstruction()
          .withArgs("map50x50", 50)
          .withAccounts(
          _base58Encoder.encodeBase58(mapAccount50x50),
          _base58Encoder.encodeBase58(map50x50.publicKey),
          systemProgram)
          .toTransaction(programId, blockhash)
          .signTransaction([await map50x50.toKeyPair()]);

      expect(transaction50x50.noSignatures, 1);
      expect(transaction50x50.message.header.noSigs, 1);
      expect(transaction50x50.message.header.noSignedReadOnlyAccounts, 0);
      expect(transaction50x50.message.header.noUnsignedReadOnlyAccounts, 2);
      expect(transaction50x50.message.instructions.length, 1);
      expect(transaction50x50.message.instructions[0].programIdIndex, 3);
      expect(transaction50x50.message.instructions[0].accountIndices, Uint8List.fromList([1, 0, 2]));

      AnchorInstructionData instructionData50x50 = transaction50x50.message.instructions[0].data as AnchorInstructionData;

      expect(instructionData50x50.discriminator, _anchorEncoder.encodeDiscriminator("global", "create_map"));

      expect(
          _base58Encoder.encodeBase58(transaction50x50.serialize()),
          "LkB54dY1QV7BJDkLyUikGXGfyU3H4KigWLNhdvXm6ycdFJA6sYurZfb9QxNn7urmK5tSZLnnbPaQQFPsmereokmEZ79hy1AHhWpmzAMyZVng7SucADSUPeV9hUK1BgBKSdNFdDipMbteTQWPyHmeoaKVsWnVn27reHcjXnX1UUZ8p9oRtQjNbY3MB1iZNFnsqdUQDpZ8k25av6F1GCUMhswXVLuKbNbSYmQg3sCUDxgM7jvDjrt4iQnFrVZTbow9CtsDnbM1UAAKC6cBRHfEjnhCjTBymDdsrwPf6732nvUxPo42aDH8ExjvUU7FkiNZVVBwFNvDMgaKkCunbTVChVJpCXbirDnWKq"
      );
    });

    test('anchorInstructionToTransaction3', () async {
      var blockhash = "563MEMYqt2tQuaAM6aWwcfgsNdopaetuqABoEAiVnsAk";
      var programId = _idl.metadata.address;

      var map100x100 = SolanaKeyPair(
          _base58Encoder.decodeBase58("3AUSdjx2weJqQemFWdNorzGSX7eJqnK8VJcdWekcG5gP"),
          Uint8List.fromList(
              _base58Encoder.decodeBase58(
                  "4YnpxVUKcLzQap7U36ECx9FxErCgEP1mmEFdDXdanjuD8pKi8Z9R7YgQHwhJY5XHjqUAw7Dq4rgsVKMLRDKe9eMR"
              ).take(32).toList()
          )
      );

      var mapAccount100x100 = (
          await _pdaService.findProgramAddress([
            Uint8List.fromList(utf8.encode("map_account")),
            map100x100.publicKey
          ], programId)).key;

      var transaction100x100 = await SolRaiderCreateMapInstruction()
          .withArgs("map100x100", 100)
          .withAccounts(
          _base58Encoder.encodeBase58(mapAccount100x100),
          _base58Encoder.encodeBase58(map100x100.publicKey),
          systemProgram)
          .toTransaction(programId, blockhash)
          .signTransaction([await map100x100.toKeyPair()]);

      expect(transaction100x100.noSignatures, 1);
      expect(transaction100x100.message.header.noSigs, 1);
      expect(transaction100x100.message.header.noSignedReadOnlyAccounts, 0);
      expect(transaction100x100.message.header.noUnsignedReadOnlyAccounts, 2);
      expect(transaction100x100.message.instructions.length, 1);
      expect(transaction100x100.message.instructions[0].programIdIndex, 3);
      expect(transaction100x100.message.instructions[0].accountIndices, Uint8List.fromList([1, 0, 2]));

      AnchorInstructionData instructionData100x100 = transaction100x100.message.instructions[0].data as AnchorInstructionData;

      expect(instructionData100x100.discriminator, _anchorEncoder.encodeDiscriminator("global", "create_map"));

      expect(
          _base58Encoder.encodeBase58(transaction100x100.serialize()),
        "AvcJpEXcugPr2ky3psgLVokSkY3zwAnaDCew8eADYjxSz2Q2xn7LKj5zrPTL1DNDoDJLihptLhMDnwe9xWyNQwFVNWhJfq7SSs6o6gXWXP6Br45LqK6Ay8PAHX5ECJFNVFo9tY3v1bxL5HcKpBVCA8wuVVxaf2nxgZhzj634rzyNQJxw7j2Y2pFMpS6Dx1LTBKNE1strAGGk8hsGDvn58S7HYyixsE7oWEZVtQcNqTgLikudSHABLrqZ2Bm88o1zdx5Mfkuh8B788EqXtjWKvFtX2FvGSgVUvo9Me54xf4u9NhGGrWcbrswtvkafM4SCx3DsjVxAwvXKJAfUx9fjPEUEzSFY7chLCGmQs"
      );
    });
  });
}