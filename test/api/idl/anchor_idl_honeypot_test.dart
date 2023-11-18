import 'dart:convert';
import 'dart:typed_data';

import 'package:solana_wallet/domain/model/derivation/solana/solana_keypair.dart';
import 'package:solana_wallet/domain/model/transaction/anchor/anchor_instruction_data.dart';
import 'package:solana_wallet/domain/service/pda_service.dart';
import 'package:solana_wallet/encoder/anchor/anchor_encoder.dart';
import 'package:solana_wallet/encoder/base58/base_58_encoder.dart';
import 'package:solana_wallet/generated/honeypot.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('AnchorIDL', () {
    late Base58Encoder _base58Encoder;
    late AnchorEncoder _anchorEncoder;
    late PDAService _pdaService;

    late HoneypotAnchorIDL _idl;

    const String expectLoginTransaction =
        "2WV4KVH2WF6ZjbZ1GwjS64w7Vt2ns" +
        "pA6eRaLznjQa1fR2n8h8x7717EeMg" +
        "N6sbeTR7Pfr6bXmvwfRaLpqYB4c1r" +
        "ZMd2ue6Vh7rVGGbepYnTW3FQHBs9r" +
        "8rJUcawdHnz97pmnsKWZrQnQhvfoz" +
        "bAMpm7nMsLrgy4Ui2XtM9DxJNexk5" +
        "LxVksu4bnXtHVDMiSK2WGGgoUtG3y" +
        "tgLPgcm8JnHz8uZj9atrupQq9NezV" +
        "Y7NEskvf4ed531L7rzwRfcATKR6Sq" +
        "SSicCsbRvv7DHvr8b9CWowmUKcQZt" +
        "Jf5Sndjts8F6niZa5Ac6zMXLcY47Q" +
        "kHmJoWez3ak6e8rkXMeHeiQiqwwWk" +
        "sVTA5JaCqwMwqcSmeXaT6uX8PRAM6" +
        "29KdtEYGdtaMp1WXKRsA37ndzqtcV" +
        "YB5UXkMK6zSGxgkUT";

    const String expectPingTransaction =
        "xaZi5f7h81Unu9LcBt6VDQcaCDqfg" +
        "DhJXq49nnd8nQh4JxivH5MxZW3DjF" +
        "r1Rt1NKyDbpiFUGSbk6yVMdaoN223" +
        "FEakKgUTBuyHDh3edFBxD6AVmrkh6" +
        "8z6GAp329BiendSXLRFV5y2W7L8Fg" +
        "aqQmSJUMAEAEartMXB3dwExoC9gyx" +
        "SHjmpbzc55YXXGzrdD1oowotWmYuW" +
        "NVPiequFgaAUXsJCirB5C72EBBuGJ" +
        "DR9YTvpYVhp7QiHwdf9taBtoayNm9" +
        "4TN5xHpT5BgBzGU6ziPHDRyeMqHSA" +
        "LC7RVLRRTdywjAxqjCrBmErrieobp" +
        "1BVLZbuf9xwYc";

    const String expectEngageTransaction =
        "EThQ4oQKZUVRzFLJhuGH8ogQrR3xf2N" +
        "h1WsMiiip5YTvZV4nM374oxwdAKxRxQ" +
        "m5iJ38jRkZyJ8WZLdcYHT3P6CHu88dN" +
        "avEbNG9yDBK9qwJVWpSNLgQuYQ2VWXV" +
        "CYiWqNad2M4i4tBNvoKpjtXGyXFG6rQ" +
        "S351cJAywsWVFXVGpn77NbiwpBTv5Ax" +
        "Yk7zwSqbqbkYTiGgDAQXJRs7eoRLv3d" +
        "1xVGJQsYR3b1nePK4wgFvdfaAqALNJ9" +
        "DM8AQ4GoVATr1pSKiUaUQNd9yXyV3f2" +
        "FaW8CeiAexhowyTcdxXJVGuLsHJGvTu" +
        "iTVAoBVLbwbNzUZW88P3Hn8n1fS9xMv" +
        "5G9WAphLyRv786suL3UsC5jVKwm4Cti" +
        "HPLeCCcgf3W7savtVtyorQqR8Mg6ZsL" +
        "ggE7Uu2v2QjMxxUY16Xsv38AdN8AhUr" +
        "KizfCBTkvZoRiUtJtAgr7yXoZrohC53" +
        "n1aD27JuaEm88LjDMHsPS3zi4zLPXbK" +
        "1H9Lm8EqPCUsQif2e9";

    setUp(() async {
      _base58Encoder = Base58Encoder();
      _anchorEncoder = AnchorEncoder();
      _pdaService = PDAService();

      _idl = HoneypotAnchorIDL()
        ..initialize();
    });

    test('login instruction to transaction', () async {
      var blockhash = "563MEMYqt2tQuaAM6aWwcfgsNdopaetuqABoEAiVnsAk";
      var programId = _idl.metadata.address;

      var signerSecert = "fWPVvAFaVWzRTNKbL51mmCq2eTnbzEpNNTMkMFR3Vta6xEFZBqZg5AeXkm1ANiC4oo4PimyhVBjMuM3x96ckmon";

      var player = "8rVNjLGctXjjDBayZ9o4uTKR2h3B8WM6ViYNCpxP7Phz";

      var playerAccount = "4LLCGGNYVEkAczfpC52UrPBuwzDepRjTswsbSJUocQ8A";
      var gameAccount = "Gn4atCUBKtehgfpp6VqZKTknw7tvyRw5BXJBmTNVkJ68";
      var systemProgram = "11111111111111111111111111111111";
      var recentSlotHashes = "SysvarS1otHashes111111111111111111111111111";

      var playerKeyPair = await SolanaKeyPair(
          _base58Encoder.decodeBase58(player), Uint8List.fromList(
          _base58Encoder.decodeBase58(signerSecert).take(32).toList()))
          .toKeyPair();

      var transactionLogin = await HoneypotLoginInstruction()
          .withArgs()
          .withAccounts(
          playerAccount, gameAccount, player, systemProgram, recentSlotHashes)
          .toTransaction(programId, blockhash)
          .signTransaction([playerKeyPair]);

      expect(transactionLogin.noSignatures, 1);
      expect(transactionLogin.message.header.noSigs, 1);
      expect(transactionLogin.message.header.noSignedReadOnlyAccounts, 0);
      expect(transactionLogin.message.header.noUnsignedReadOnlyAccounts, 3);
      expect(transactionLogin.message.instructions.length, 1);
      expect(transactionLogin.message.instructions[0].programIdIndex, 4);
      expect(transactionLogin.message.accountAddresses, [
        '8rVNjLGctXjjDBayZ9o4uTKR2h3B8WM6ViYNCpxP7Phz',
        '4LLCGGNYVEkAczfpC52UrPBuwzDepRjTswsbSJUocQ8A',
        'Gn4atCUBKtehgfpp6VqZKTknw7tvyRw5BXJBmTNVkJ68',
        '11111111111111111111111111111111',
        'D3Fmzy6k3JnHt6rxxrExxW9MnjdSCBF8A7PfFnyvxZY6',
        'SysvarS1otHashes111111111111111111111111111',
      ]);
      expect(transactionLogin.message.instructions[0].accountIndices,
          Uint8List.fromList([1, 2, 0, 3, 5]));

      AnchorInstructionData instructionData = transactionLogin.message
          .instructions[0].data as AnchorInstructionData;

      expect(instructionData.discriminator,
          _anchorEncoder.encodeDiscriminator("global", "login"));

      expect(
          _base58Encoder.encodeBase58(transactionLogin.serialize()),
          expectLoginTransaction);
    });

    test('ping instruction to transaction', () async {
      var blockhash = "563MEMYqt2tQuaAM6aWwcfgsNdopaetuqABoEAiVnsAk";
      var programId = _idl.metadata.address;

      var signerSecert = "fWPVvAFaVWzRTNKbL51mmCq2eTnbzEpNNTMkMFR3Vta6xEFZBqZg5AeXkm1ANiC4oo4PimyhVBjMuM3x96ckmon";

      var player = "8rVNjLGctXjjDBayZ9o4uTKR2h3B8WM6ViYNCpxP7Phz";

      var playerAccount = "4LLCGGNYVEkAczfpC52UrPBuwzDepRjTswsbSJUocQ8A";
      var gameAccount = "Gn4atCUBKtehgfpp6VqZKTknw7tvyRw5BXJBmTNVkJ68";

      var playerKeyPair = await SolanaKeyPair(
          _base58Encoder.decodeBase58(player), Uint8List.fromList(
          _base58Encoder.decodeBase58(signerSecert).take(32).toList()))
          .toKeyPair();

      var transactionLogin = await HoneypotPingInstruction()
          .withArgs()
          .withAccounts(playerAccount, gameAccount, player)
          .toTransaction(programId, blockhash)
          .signTransaction([playerKeyPair]);

      expect(
          transactionLogin.noSignatures, 1);

      expect(
          transactionLogin.message.header.noSigs, 1);

      expect(
          transactionLogin.message.header.noSignedReadOnlyAccounts, 0);

      expect(
          transactionLogin.message.header.noUnsignedReadOnlyAccounts, 1);

      expect(
          transactionLogin.message.instructions.length, 1);

      expect(
          transactionLogin.message.instructions[0].programIdIndex, 3);

      expect(
          transactionLogin.message.accountAddresses, [
        "8rVNjLGctXjjDBayZ9o4uTKR2h3B8WM6ViYNCpxP7Phz",
        "4LLCGGNYVEkAczfpC52UrPBuwzDepRjTswsbSJUocQ8A",
        "Gn4atCUBKtehgfpp6VqZKTknw7tvyRw5BXJBmTNVkJ68",
        "D3Fmzy6k3JnHt6rxxrExxW9MnjdSCBF8A7PfFnyvxZY6"
      ]);

      expect(
          transactionLogin.message.instructions[0].accountIndices,
          Uint8List.fromList([1, 2, 0]));

      AnchorInstructionData instructionData = transactionLogin.message
          .instructions[0].data as AnchorInstructionData;
      expect(instructionData.discriminator,
          _anchorEncoder.encodeDiscriminator("global", "ping"));

      expect(
          _base58Encoder.encodeBase58(transactionLogin.serialize()),
          expectPingTransaction);
    });

    test('engage instruction to transaction', () async {
      var blockhash = "563MEMYqt2tQuaAM6aWwcfgsNdopaetuqABoEAiVnsAk";
      var programId = _idl.metadata.address;
      var signerSecert = "fWPVvAFaVWzRTNKbL51mmCq2eTnbzEpNNTMkMFR3Vta6xEFZBqZg5AeXkm1ANiC4oo4PimyhVBjMuM3x96ckmon";
      
      var player = "8rVNjLGctXjjDBayZ9o4uTKR2h3B8WM6ViYNCpxP7Phz";

      var challenger = "9XkK1fEkZUKWVNQFZH9kLFkaPmboiF94ofrsZeFAxSut";
      var defender = "8rVNjLGctXjjDBayZ9o4uTKR2h3B8WM6ViYNCpxP7Phz";
      
      var challengerAccount = "AGAH3hkzVWwpYddpU3vuMxFQFev8GeyE5tirCnPnZCgS";
      var defenderAccount = "4LLCGGNYVEkAczfpC52UrPBuwzDepRjTswsbSJUocQ8A";

      var gameAccount = "Gn4atCUBKtehgfpp6VqZKTknw7tvyRw5BXJBmTNVkJ68";
      var engageAccount = "BYgfK9ZREzcVwAkhQ9wjMtktFcFFzV9x8mT65MrizYri";

      var systemProgram = "11111111111111111111111111111111";

      var playerKeyPair = await SolanaKeyPair(
          _base58Encoder.decodeBase58(player), Uint8List.fromList(
          _base58Encoder.decodeBase58(signerSecert).take(32).toList()))
          .toKeyPair();
      
      var transactionEngage = await HoneypotEngageInstruction()
          .withArgs()
          .withAccounts(challengerAccount, defenderAccount, gameAccount, engageAccount, player, challenger, defender, systemProgram)
          .toTransaction(programId, blockhash)
          .signTransaction([playerKeyPair]);

      expect(
          transactionEngage.noSignatures, 1);

      expect(
          transactionEngage.message.header.noSigs, 1);

      expect(
          transactionEngage.message.header.noSignedReadOnlyAccounts, 0);

      expect(
          transactionEngage.message.header.noUnsignedReadOnlyAccounts, 3);

      expect(
          transactionEngage.message.instructions.length, 1);

      expect(
          transactionEngage.message.accountAddresses, [
            "8rVNjLGctXjjDBayZ9o4uTKR2h3B8WM6ViYNCpxP7Phz",
            "4LLCGGNYVEkAczfpC52UrPBuwzDepRjTswsbSJUocQ8A",
            "AGAH3hkzVWwpYddpU3vuMxFQFev8GeyE5tirCnPnZCgS",
            "BYgfK9ZREzcVwAkhQ9wjMtktFcFFzV9x8mT65MrizYri",
            "Gn4atCUBKtehgfpp6VqZKTknw7tvyRw5BXJBmTNVkJ68",
            "11111111111111111111111111111111",
            "9XkK1fEkZUKWVNQFZH9kLFkaPmboiF94ofrsZeFAxSut",
            "D3Fmzy6k3JnHt6rxxrExxW9MnjdSCBF8A7PfFnyvxZY6"
      ]);

      expect(
          transactionEngage.message.instructions[0].programIdIndex, 7);

      expect(
          transactionEngage.message.instructions[0].accountIndices,
          Uint8List.fromList([2, 1, 4, 3, 0, 6, 0, 5]));

      AnchorInstructionData instructionData = transactionEngage.message
          .instructions[0].data as AnchorInstructionData;
      expect(instructionData.discriminator,
          _anchorEncoder.encodeDiscriminator("global", "engage"));

      expect(
          _base58Encoder.encodeBase58(transactionEngage.serialize()),
          expectEngageTransaction);
    });
  });
}