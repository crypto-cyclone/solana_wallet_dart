import 'dart:typed_data';

import 'package:solana_wallet/api/idl/anchor_idl.dart';
import 'package:solana_wallet/constants/solana/program_library.dart';
import 'package:solana_wallet/domain/model/derivation/solana/solana_keypair.dart';
import 'package:solana_wallet/domain/model/transaction/anchor/anchor_instruction_data.dart';
import 'package:solana_wallet/encoder/anchor/anchor_encoder.dart';
import 'package:solana_wallet/encoder/base58/base_58_encoder.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('AnchorIDL', () {
    late Base58Encoder _base58Encoder;
    late AnchorEncoder _anchorEncoder;
    late AnchorInstruction instruction;

    setUp(() {
      _base58Encoder = Base58Encoder();
      _anchorEncoder = AnchorEncoder();

      instruction = AnchorInstruction(
          name: "createMap",
          args: {
            'name': AnchorFieldString(name: 'name', value: 'SolRaider', index: 0),
            'size': AnchorFieldU64(name: 'size', value: 20, index: 1),
            'reward': AnchorFieldU64(name: 'reward', value: 100, index: 2),
          },
          accounts: {
            'mapAccount': AnchorInstructionAccount(
                name: 'mapAccount',
                isMut: true,
                isSigner: false,
                address: 'Ah7nQNvEu1yiMYK6hquA8YQJs2QGm9VzJ3S5XT4ThKb5',
                index: 0
            ),
            'owner': AnchorInstructionAccount(
                name: 'owner',
                isMut: true,
                isSigner: true,
                address: '8R2PWkbC1Btt6SP15TQagSg4eCsNkCRrAqLhpN7ZgSpM',
                index: 1
            ),
            'systemProgram': AnchorInstructionAccount(
                name: 'systemProgram',
                isMut: false,
                isSigner: false,
                address: systemProgram,
                index: 2
            ),
          }
      );
    });

    test('anchorInstructionToTransaction', () async {
      var transaction = instruction.toTransactionUnsafe(
        "8WdhLFkpr5sudFiCP1WknJvxVRagsUV6ohmKXuNBMZwG",
        "4rrjjiigCKkQaFGx43QoGXdX7AhAqNfP24dkNDKVKFh4"
      );

      var keyPair = SolanaKeyPair(
          _base58Encoder.decodeBase58("8R2PWkbC1Btt6SP15TQagSg4eCsNkCRrAqLhpN7ZgSpM"),
          Uint8List.fromList(
              _base58Encoder.decodeBase58(
                  "466AVjzWRLScurWJNvBzPGMG4rfMhZn1XWF3oru5KP6XUN2LcKB2R6mhncpKh3C4REPGWs19qy4gf6gEF6A3aE9B"
              ).take(32).toList()
          )
      );

      transaction = await transaction.signTransaction([await keyPair.toKeyPair()]);

      expect(transaction.noSignatures, 1);
      expect(transaction.message.header.noSigs, 1);
      expect(transaction.message.header.noSignedReadOnlyAccounts, 0);
      expect(transaction.message.header.noUnsignedReadOnlyAccounts, 2);
      expect(transaction.message.instructions.length, 1);
      expect(transaction.message.instructions[0].programIdIndex, 3);
      expect(transaction.message.instructions[0].accountIndices, Uint8List.fromList([1, 0, 2]));

      AnchorInstructionData instructionData = transaction.message.instructions[0].data as AnchorInstructionData;

      expect(instructionData.discriminator, _anchorEncoder.encodeDiscriminator("global", "create_map"));

      expect(
          _base58Encoder.encodeBase58(transaction.serialize()),
          "7z6cQfFpyDUqhoXV5tbTvX9rw2vYxan3EqNL4V5PdFTcyb5W1Rfuum1u8qv7mp4xzfDTBFAxDFepema6dM1WAZPDiDrZrovvsNwEMFPTNGbDmVRqrBstvWJ6mrKJagMT5URwy7tQWUQxHZrS3ripSKKjMfRmSJFdDKo8yA9on7SoYXym1gPzA53KXeVQdWjG8DgxR26WTiwe8E8atsKqJL2RC5bpmLQ2J9JMZxnQUXPHKgrNtcmTdcLB6X6Td3sXMiLnBRaaWig3JgVVVaqByR5BoyQ9A5reUTfNM6cGHv44gJcHVehjMnxUBhyMCAMH8eiCeHe3VWwUtXtx2vpNgzWjekLCnozvBVWXUikzb7ifeutrPAkX"
      );
    });
  });
}