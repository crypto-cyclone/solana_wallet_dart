import 'dart:typed_data';

import 'package:solana_wallet/api/idl/anchor_idl.dart';
import 'package:solana_wallet/domain/model/derivation/solana/solana_keypair.dart';
import 'package:solana_wallet/domain/model/transaction/anchor/anchor_instruction_data.dart';
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
    late AnchorEncoder _anchorEncoder;
    late SolanaEncoder _solanaEncoder;
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

    const String expectPlayTransaction =
        "mUc4FH3xYBQz8ntLEcpYNtyRNN36y9" +
        "73fAQYEnsz5F4qjGTGuku5ow8HNaHU" +
        "Sv4je8nsyMDc9zvpAaxYZoniEe7kmR" +
        "T8yYQJT2NB2Jdviz1r3uDWGBNL5hHm" +
        "h1dErukVAGkRpubzVrpdmohcUa1TEb" +
        "s5hxnvhZMdxomiLRe5oPsDtb1A2UAb" +
        "6pFgDEAYhgVLmeA4AXX4UrHhPomAWa" +
        "YHyuWLKdogyuBUXUmkLVr18FDByqJo" +
        "v5i4aTt1xRoWgUCXKLxu8V8eH8BEtX" +
        "TGsZRTg5V7U9nyruoQCDxSgNdFtsJm" +
        "nuidvybLDXcE59kENRrxuD5W1r1WA7" +
        "kvKoHqenwMmoakDt1BvgiBk2QybwjM" +
        "izi9XgdTEG7ACobrwBvZzQCCDZiFMc" +
        "f2EKaGdTDQobTJSDKoFqkEuqzN2wSe" +
        "4BG82KE31zCKEAp73C9sWaMnM9CWRC" +
        "nCTkqi22FTYmvCJwTwRDHGq47Aevpm" +
        "fUdDbjPro5AtvrQHPBPDJHJx79QB5V" +
        "Vrjn8NdEXKSWgZSW11njSyF9JHsguk" +
        "kgNYRwqjiTZL9pnU";

    const String expectRevealTransaction =
        "7Gqyuzt1P3gh5f6kkGZPGNsrKS1F9xXM" +
        "mprZCZbFzHtrSLNeRyG9UJUcCALgdGC6" +
        "A6xpCAsKUa6zv97T5yfAKsA6iLuwhLEA" +
        "capeqLRiH7JQFj9skQtkQaqYmXPQEQCy" +
        "g27GP7NqF3S6PfGCj4vTCCmzCuN6SMXA" +
        "giyDJ9k35WsgujCm76cSuKQdrqkdcXRK" +
        "mZE7CTe3J2fsDBFHFoG5XNiBrXCDtosw" +
        "QbNpWouSbeWESLHNKP1EdZojYudJZ5bQ" +
        "i2Mg28VT8LzVf6sGeszZ6bZwpceWWY8y" +
        "E1qZkMHWKtoAC93YJ8EQtrehKudDEJhf" +
        "bYuj2DWzJwJNU49msXFZp32zBF3fi6mu" +
        "Zs8NTM3wedFZoRDzitwApR7XUb6LadjV" +
        "8hFGWRwpXx8eNg3GMRD5vJTFfD59VDsJ" +
        "jQLFenRNqBuztU5zmJaincYJYmwaTzma" +
        "nr6WSXZsWHgYnPVjSweFPNxGX7ccQXX9" +
        "PxWn1br4Y56XRjFFvh2VmSmiobWZYRir" +
        "LWgTQByPaXsYPUyPrBLdKJqq";

    setUp(() async {
      _base58Encoder = Base58Encoder();
      _anchorEncoder = AnchorEncoder();
      _pdaService = PDAService();
      _solanaEncoder = SolanaEncoder();

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

      var transaction = await HoneypotLoginInstruction()
          .withArgs()
          .withAccounts(
          playerAccount, gameAccount, player, systemProgram, recentSlotHashes)
          .toTransaction(programId, blockhash)
          .signTransaction([playerKeyPair]);

      expect(transaction.noSignatures, 1);
      expect(transaction.message.header.noSigs, 1);
      expect(transaction.message.header.noSignedReadOnlyAccounts, 0);
      expect(transaction.message.header.noUnsignedReadOnlyAccounts, 3);
      expect(transaction.message.instructions.length, 1);
      expect(transaction.message.instructions[0].programIdIndex, 4);
      expect(transaction.message.accountAddresses, [
        '8rVNjLGctXjjDBayZ9o4uTKR2h3B8WM6ViYNCpxP7Phz',
        '4LLCGGNYVEkAczfpC52UrPBuwzDepRjTswsbSJUocQ8A',
        'Gn4atCUBKtehgfpp6VqZKTknw7tvyRw5BXJBmTNVkJ68',
        '11111111111111111111111111111111',
        'D3Fmzy6k3JnHt6rxxrExxW9MnjdSCBF8A7PfFnyvxZY6',
        'SysvarS1otHashes111111111111111111111111111',
      ]);
      expect(transaction.message.instructions[0].accountIndices,
          Uint8List.fromList([1, 2, 0, 3, 5]));

      AnchorInstructionData instructionData = transaction.message
          .instructions[0].data as AnchorInstructionData;

      expect(instructionData.discriminator,
          _anchorEncoder.encodeDiscriminator("global", "login"));

      expect(
          _base58Encoder.encodeBase58(transaction.serialize()),
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

      var transaction = await HoneypotPingInstruction()
          .withArgs()
          .withAccounts(playerAccount, gameAccount, player)
          .toTransaction(programId, blockhash)
          .signTransaction([playerKeyPair]);

      expect(
          transaction.noSignatures, 1);

      expect(
          transaction.message.header.noSigs, 1);

      expect(
          transaction.message.header.noSignedReadOnlyAccounts, 0);

      expect(
          transaction.message.header.noUnsignedReadOnlyAccounts, 1);

      expect(
          transaction.message.instructions.length, 1);

      expect(
          transaction.message.instructions[0].programIdIndex, 3);

      expect(
          transaction.message.accountAddresses, [
        "8rVNjLGctXjjDBayZ9o4uTKR2h3B8WM6ViYNCpxP7Phz",
        "4LLCGGNYVEkAczfpC52UrPBuwzDepRjTswsbSJUocQ8A",
        "Gn4atCUBKtehgfpp6VqZKTknw7tvyRw5BXJBmTNVkJ68",
        "D3Fmzy6k3JnHt6rxxrExxW9MnjdSCBF8A7PfFnyvxZY6"
      ]);

      expect(
          transaction.message.instructions[0].accountIndices,
          Uint8List.fromList([1, 2, 0]));

      AnchorInstructionData instructionData = transaction.message
          .instructions[0].data as AnchorInstructionData;
      expect(instructionData.discriminator,
          _anchorEncoder.encodeDiscriminator("global", "ping"));

      expect(
          _base58Encoder.encodeBase58(transaction.serialize()),
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
      
      var transaction = await HoneypotEngageInstruction()
          .withArgs()
          .withAccounts(challengerAccount, defenderAccount, gameAccount, engageAccount, player, challenger, defender, systemProgram)
          .toTransaction(programId, blockhash)
          .signTransaction([playerKeyPair]);

      expect(
          transaction.noSignatures, 1);

      expect(
          transaction.message.header.noSigs, 1);

      expect(
          transaction.message.header.noSignedReadOnlyAccounts, 0);

      expect(
          transaction.message.header.noUnsignedReadOnlyAccounts, 3);

      expect(
          transaction.message.instructions.length, 1);

      expect(
          transaction.message.accountAddresses, [
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
          transaction.message.instructions[0].programIdIndex, 7);

      expect(
          transaction.message.instructions[0].accountIndices,
          Uint8List.fromList([2, 1, 4, 3, 0, 6, 0, 5]));

      AnchorInstructionData instructionData = transaction.message
          .instructions[0].data as AnchorInstructionData;
      expect(instructionData.discriminator,
          _anchorEncoder.encodeDiscriminator("global", "engage"));

      expect(
          _base58Encoder.encodeBase58(transaction.serialize()),
          expectEngageTransaction);
    });

    test('play instruction to transaction', () async {
      var blockhash = "563MEMYqt2tQuaAM6aWwcfgsNdopaetuqABoEAiVnsAk";
      var programId = _idl.metadata.address;
      var signerSecert = "fWPVvAFaVWzRTNKbL51mmCq2eTnbzEpNNTMkMFR3Vta6xEFZBqZg5AeXkm1ANiC4oo4PimyhVBjMuM3x96ckmon";

      var player = "8rVNjLGctXjjDBayZ9o4uTKR2h3B8WM6ViYNCpxP7Phz";
      var opponent = "9XkK1fEkZUKWVNQFZH9kLFkaPmboiF94ofrsZeFAxSut";
      
      var playerAccount = "4LLCGGNYVEkAczfpC52UrPBuwzDepRjTswsbSJUocQ8A";
      var opponentAccount = "AGAH3hkzVWwpYddpU3vuMxFQFev8GeyE5tirCnPnZCgS";

      var gameAccount = "Gn4atCUBKtehgfpp6VqZKTknw7tvyRw5BXJBmTNVkJ68";
      var engageAccount = "BYgfK9ZREzcVwAkhQ9wjMtktFcFFzV9x8mT65MrizYri";

      var systemProgram = "11111111111111111111111111111111";

      var playerKeyPair = await SolanaKeyPair(
          _base58Encoder.decodeBase58(player), Uint8List.fromList(
          _base58Encoder.decodeBase58(signerSecert).take(32).toList()))
          .toKeyPair();

      var rawHashedMove = _base58Encoder.decodeBase58("7Bz6Bkinxwg6ppHDojzh2UeohSxvEqvic8VWptHvxTxL").toList();

      var hashedMove = AnchorFieldVector<AnchorFieldU8>(
        value : rawHashedMove.map((e) =>
            AnchorFieldU8(value: e)).toList()
      );

      var sealedMove = HoneypotSealedMoveStruct().hashedMoveField.withValue(hashedMove.value);
      var sealedMoveStruct = HoneypotSealedMoveStruct.withFields(hashedMoveField: sealedMove);

      var transaction = await HoneypotPlayInstruction()
          .withArgs(sealedMoveStruct)
          .withAccounts(playerAccount, opponentAccount, gameAccount, engageAccount, player, opponent, systemProgram)
          .toTransaction(programId, blockhash)
          .signTransaction([playerKeyPair]);

      expect(
          transaction.noSignatures, 1);

      expect(
          transaction.message.header.noSigs, 1);

      expect(
          transaction.message.header.noSignedReadOnlyAccounts, 0);

      expect(
          transaction.message.header.noUnsignedReadOnlyAccounts, 3);

      expect(
          transaction.message.instructions.length, 1);

      expect(
          transaction.message.accountAddresses, [
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
          transaction.message.instructions[0].programIdIndex, 7);

      expect(
          transaction.message.instructions[0].accountIndices,
          Uint8List.fromList([1, 2, 4, 3, 0, 6, 5]));

      AnchorInstructionData instructionData = transaction.message
          .instructions[0].data as AnchorInstructionData;

      expect(instructionData.discriminator,
          _anchorEncoder.encodeDiscriminator("global", "play"));

      expect(
          _base58Encoder.encodeBase58(transaction.serialize()),
          expectPlayTransaction);
    });

    test('reveal instruction to transaction', () async {
      var blockhash = "563MEMYqt2tQuaAM6aWwcfgsNdopaetuqABoEAiVnsAk";
      var programId = _idl.metadata.address;
      var signerSecert = "fWPVvAFaVWzRTNKbL51mmCq2eTnbzEpNNTMkMFR3Vta6xEFZBqZg5AeXkm1ANiC4oo4PimyhVBjMuM3x96ckmon";

      var player = "8rVNjLGctXjjDBayZ9o4uTKR2h3B8WM6ViYNCpxP7Phz";
      var opponent = "9XkK1fEkZUKWVNQFZH9kLFkaPmboiF94ofrsZeFAxSut";

      var playerAccount = "4LLCGGNYVEkAczfpC52UrPBuwzDepRjTswsbSJUocQ8A";
      var opponentAccount = "AGAH3hkzVWwpYddpU3vuMxFQFev8GeyE5tirCnPnZCgS";

      var gameAccount = "Gn4atCUBKtehgfpp6VqZKTknw7tvyRw5BXJBmTNVkJ68";
      var engageAccount = "BYgfK9ZREzcVwAkhQ9wjMtktFcFFzV9x8mT65MrizYri";

      var systemProgram = "11111111111111111111111111111111";

      var playerKeyPair = await SolanaKeyPair(
          _base58Encoder.decodeBase58(player), Uint8List.fromList(
          _base58Encoder.decodeBase58(signerSecert).take(32).toList()))
          .toKeyPair();

      var revealedMove = HoneypotRevealedMoveStruct.withFields(
          playField: AnchorFieldEnum(
              value: HoneypotMoveTypeEnum.TOKEN
          ),
          nonceField: AnchorFieldString(
              value:"sealed_moved"
          )
      );

      var transaction = await HoneypotRevealInstruction()
          .withArgs(revealedMove)
          .withAccounts(playerAccount, opponentAccount, gameAccount, engageAccount, player, opponent, systemProgram)
          .toTransaction(programId, blockhash)
          .signTransaction([playerKeyPair]);

      expect(
          transaction.noSignatures, 1);

      expect(
          transaction.message.header.noSigs, 1);

      expect(
          transaction.message.header.noSignedReadOnlyAccounts, 0);

      expect(
          transaction.message.header.noUnsignedReadOnlyAccounts, 3);

      expect(
          transaction.message.instructions.length, 1);

      expect(
          transaction.message.accountAddresses, [
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
          transaction.message.instructions[0].programIdIndex, 7);

      expect(
          transaction.message.instructions[0].accountIndices,
          Uint8List.fromList([1, 2, 4, 3, 0, 6, 5]));

      AnchorInstructionData instructionData = transaction.message
          .instructions[0].data as AnchorInstructionData;

      expect(instructionData.discriminator,
          _anchorEncoder.encodeDiscriminator("global", "reveal"));

      expect(
          _base58Encoder.encodeBase58(transaction.serialize()),
          expectRevealTransaction);
    });
  });
}