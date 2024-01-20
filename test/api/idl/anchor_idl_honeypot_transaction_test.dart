import 'dart:convert';
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
        "2LaRBvdTzzoxBeHuJ35Gbh3NQUQecj" +
        "iAax9MTqULSeZHVjzzQyyX1QHK4Cf8" +
        "WVQVM3rQY8kFEBVDGSWj4oaxiKtN1Q" +
        "K3HudZu1ZSN9kQoY6WvhqFnRLt625f" +
        "gYt7RG5yLNi9VitkS9WUfsP21vLcw7" +
        "UboFU4mhE5yGSAb8sJHdoJy91pLEXP" +
        "GT8LZDpQCj194FzUjjqAyHaAgUFzBC" +
        "qoyYkXh13DVA22Chd8pRBYTtJEM7VR" +
        "tBxnfHiWQyzGwUTLWqVi3i3VrL43eM" +
        "6x9bz6Ty7Gc8E4NPTY7ok8XDeJ6zzq" +
        "dWPka7AEKyxtHtD47RDe2RbN54PJSo" +
        "SzSfHBdNLJem3pr6akNDegjD9dEZJ4" +
        "Xp7U5h7kGt9RwGFrkjZYNCsBF1otrm" +
        "3GwLRVXc8G7z812KRxprS2c8mwFFa4" +
        "aByyk2sDZrdthM";

    const String expectPingTransaction =
        "sv4Ed3dfUUmvwTCnQocJEE6w5Jqmyh" +
        "6tDczXnxz6o4hHmV5Q789ELZAwYMCu" +
        "ks4e1sEeR1ngQC2FDDzBDSBamMGB3K" +
        "YE8q7jna9DGXx8yCqQ4CAMaD6oCiYb" +
        "9QTAwnEY6HFv7xCkoUe5sBrBnZ2yRK" +
        "WwkdsgbyRTEwamptYnDMBx9U1Jwr5U" +
        "DCf7gz7vGBUZwDsFc2cfZPnF4cR52T" +
        "UPtxBqZqtBKo8EXiKJvCepbmGBBToU" +
        "9UhNZEtWppJaqq9WHn1bESzjwnFvhJ" +
        "JoCF6TBNBHV4NdfY7Dr4YWPg3UmLH4" +
        "NLDpU9pcVNHcF883ZuicppFf6Ge1N4" +
        "xG";

    const String expectEngageTransaction =
        "E8XjDoeFVjxgx9gQQao1cHerAmJ4td" +
        "5FfqshWJydBDDqZeZDM24KzG7d3igJ" +
        "2dbTjPsV8eB8pHeC4SDYL3hfLTW815" +
        "FBUPE3eGEZWiuDdLon8uy64HVY5py8" +
        "giPcpTbWiiJXKkM7ZRYAZw1kJad1Rm" +
        "w1uZMKDfivy8TQzMtA2Q3e7VaxLqEr" +
        "XxdvAnEpCfh7fiFAUi1TpmhMQDzc1b" +
        "PFf6wWaT4NKaNUEXzdJqXQQWcm4kgU" +
        "ZH7XCj9PPNvQ7Xrcqz8izwVSjo7ZEk" +
        "PcsaJHE8YADM4HgDXpHsCzSgZKFzAH" +
        "f5CXqHEoFXxiUHaq8yKdP4cUVg6ffb" +
        "6AWp8YQeWnCDQbi1NkUtsSpikPBGQt" +
        "F2TPqXZvqbsRqRbz7bTG4yiqEoqxBM" +
        "KjYcHcHGBqLtXqx8WWJxG5T3FKWM34" +
        "p7xvEPCwrN6sxJFW7jfoA1xWmdDqZb" +
        "ugWnbxkVAMvuQSiSVkA38PmfcXqQEz" +
        "Tsvhfs9fySAKoWHeLBgtaqWMfCfeRy" +
        "bdi5";

    const String expectPlayTransaction =
        "qufmRX7sguiZZ9ozTqM7XhJ1w1QLe" +
        "A3fZYR7EZ57K69FaJVb4r14Ds6Ec6" +
        "Ygz5WWGxSFACtkA5t8iTNxptLV7vy" +
        "j9vbp6k2hp3RwLA1wSB4kzUNHxgDm" +
        "sfUUay3D1rwdMSrWhFrSJZC31Lrfj" +
        "6gYLWakjLvCSReLy6w3QvnvFVEjNb" +
        "Qqa4hvnuamnnm616F1SALX7gFru1B" +
        "8pDZRdzENGZ9b63oPSs7ndtNNAuJY" +
        "MGvxsL8GQyiUKkVLHoz7KTsDxWgUr" +
        "pWjUmHZEGYuwSginkosMsR8LKbpjv" +
        "d3vSUcByrFYRUqTQukSj8vzUDNsVb" +
        "4Yy45XRNcp1YWu7mwiVdRCWcoZF17" +
        "6a5sFdYAaxKANTrFSpP2f9AiH5DPi" +
        "9qse12xS9PyQVREUcUZfQZmkxBaMN" +
        "4Mmsg3q87PMYaT2k2HVSTQvSA1sft" +
        "PVkmjbabQmgt6DLxExNaR9enJ8nEC" +
        "YFvPYjuRyFBeZ9AMLLadprQoYb19L" +
        "aFugAWc4ZtDHaFfHbsS4hEvfpQwKg" +
        "Y2p3Q5MbsMMBHFDrS9ZCXttzHmMpU" +
        "8MQbz";

    const String expectRevealTransaction =
        "6UdwxW3pHfoZQtzoETGqYdodQ76JASs" +
        "jeYCYR8Rxj7Q9VKYj2iEHpEs1JVJ4K7" +
        "JADypguSY91GpCfdnTKSF8K7DLdTFRj" +
        "mLdEdfJC4AnZLTZWoNyS6nXPSr2A5N4" +
        "wNneiEkdLhDpDaNoEr3a5bwx8E9hB3s" +
        "jMU99s7BRDzwfLid8GdP1X8R4tXjDta" +
        "5CXSDnZ7uCH2J1jQoyuQTGunGDSLH4H" +
        "6gijZ8MaZz3srNVbzccLbHpo6717wWx" +
        "5EZGbsMZdpQ3R6mitw2nJcaoFAidUty" +
        "pBy6wmAuWLLQf83YPCKeZg6zUMvcuAg" +
        "uAwiGKYga9rY1TWmZqjPqwF34LtmcA5" +
        "Fz1sihiR4KnWkWpC1qQpNHRRkXVTyKR" +
        "1CmLtfguZrrjatgr8rkR91LhJUW9XLa" +
        "AkKby1DzRNbBdxcb9ffScoMTcAejNBk" +
        "e1SMZzAheaqwhEnKA7yihKVa3QsY7JA" +
        "nrXA6ofjNAkiDohMmeuwArFXRAUHqpn" +
        "bCvHUhsDaw6oNGxofewnzgDYnTKt2EP" +
        "c4N8QgEyy";

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

      var signerSecret = "fWPVvAFaVWzRTNKbL51mmCq2eTnbzEpNNTMkMFR3Vta6xEFZBqZg5AeXkm1ANiC4oo4PimyhVBjMuM3x96ckmon";

      var player = _base58Encoder.encodeBase58(
          Uint8List.fromList(_base58Encoder.decodeBase58(signerSecret).getRange(32, 64).toList()));

      var playerAccount = _base58Encoder.encodeBase58(
          (await _pdaService.findProgramAddress([utf8.encode("player_account"), _base58Encoder.decodeBase58(player)], programId)).key);

      var gameAccount = _base58Encoder.encodeBase58(
          (await _pdaService.findProgramAddress([utf8.encode("game_account")], programId)).key);

      var systemProgram = "11111111111111111111111111111111";
      var recentSlotHashes = "SysvarS1otHashes111111111111111111111111111";

      var playerKeyPair = await SolanaKeyPair(
          _base58Encoder.decodeBase58(player), Uint8List.fromList(
          _base58Encoder.decodeBase58(signerSecret).take(32).toList()))
          .toKeyPair();

      var transaction = await HoneypotLoginInstruction()
          .withArgs([0, 0, 0, 0, 0, 0, 0, 0])
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
        player,
        playerAccount,
        gameAccount,
        systemProgram,
        programId,
        recentSlotHashes,
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

      var signerSecret = "fWPVvAFaVWzRTNKbL51mmCq2eTnbzEpNNTMkMFR3Vta6xEFZBqZg5AeXkm1ANiC4oo4PimyhVBjMuM3x96ckmon";

      var player = _base58Encoder.encodeBase58(
          Uint8List.fromList(_base58Encoder.decodeBase58(signerSecret).getRange(32, 64).toList()));

      var playerAccount = _base58Encoder.encodeBase58(
          (await _pdaService.findProgramAddress([utf8.encode("player_account"), _base58Encoder.decodeBase58(player)], programId)).key);

      var gameAccount = _base58Encoder.encodeBase58(
          (await _pdaService.findProgramAddress([utf8.encode("game_account")], programId)).key);

      var playerKeyPair = await SolanaKeyPair(
          _base58Encoder.decodeBase58(player), Uint8List.fromList(
          _base58Encoder.decodeBase58(signerSecret).take(32).toList()))
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
          player,
          playerAccount,
          gameAccount,
          programId
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
      var signerSecret = "fWPVvAFaVWzRTNKbL51mmCq2eTnbzEpNNTMkMFR3Vta6xEFZBqZg5AeXkm1ANiC4oo4PimyhVBjMuM3x96ckmon";
      var signerSecret2 = "2mDoDZb8dPzj8swAJ5uKyeHX3cm2PcNUCqQsFxTb8QQuNWoq7EC7wGVYAhfK82JSvB3V7dkTx4WyN3YPHurgDHvw";

      var player = _base58Encoder.encodeBase58(
          Uint8List.fromList(_base58Encoder.decodeBase58(signerSecret).getRange(32, 64).toList()));

      var challenger = _base58Encoder.encodeBase58(
          Uint8List.fromList(_base58Encoder.decodeBase58(signerSecret2).getRange(32, 64).toList()));

      var defender = player;

      var challengerAccount = _base58Encoder.encodeBase58(
          (await _pdaService.findProgramAddress([utf8.encode("player_account"), _base58Encoder.decodeBase58(challenger)], programId)).key);

      var defenderAccount = _base58Encoder.encodeBase58(
          (await _pdaService.findProgramAddress([utf8.encode("player_account"), _base58Encoder.decodeBase58(defender)], programId)).key);

      var gameAccount = _base58Encoder.encodeBase58(
          (await _pdaService.findProgramAddress([utf8.encode("game_account")], programId)).key);

      var engageAccount = _base58Encoder.encodeBase58(
          (await _pdaService.findProgramAddress([utf8.encode("engage_account"), _base58Encoder.decodeBase58(challenger), _base58Encoder.decodeBase58(defender)], programId)).key);

      var systemProgram = "11111111111111111111111111111111";

      var playerKeyPair = await SolanaKeyPair(
          _base58Encoder.decodeBase58(player), Uint8List.fromList(
          _base58Encoder.decodeBase58(signerSecret).take(32).toList()))
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
            player,
            defenderAccount,
            challengerAccount,
            gameAccount,
            engageAccount,
            systemProgram,
            challenger,
            programId,
      ]);

      expect(
          transaction.message.instructions[0].programIdIndex, 7);

      expect(
          transaction.message.instructions[0].accountIndices,
          Uint8List.fromList([2, 1, 3, 4, 0, 6, 0, 5]));

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
      var signerSecret = "fWPVvAFaVWzRTNKbL51mmCq2eTnbzEpNNTMkMFR3Vta6xEFZBqZg5AeXkm1ANiC4oo4PimyhVBjMuM3x96ckmon";
      var signerSecret2 = "2mDoDZb8dPzj8swAJ5uKyeHX3cm2PcNUCqQsFxTb8QQuNWoq7EC7wGVYAhfK82JSvB3V7dkTx4WyN3YPHurgDHvw";

      var player = _base58Encoder.encodeBase58(
          Uint8List.fromList(_base58Encoder.decodeBase58(signerSecret).getRange(32, 64).toList()));

      var opponent = _base58Encoder.encodeBase58(
          Uint8List.fromList(_base58Encoder.decodeBase58(signerSecret2).getRange(32, 64).toList()));

      var defender = player;
      var challenger = opponent;

      var playerAccount = _base58Encoder.encodeBase58(
          (await _pdaService.findProgramAddress([utf8.encode("player_account"), _base58Encoder.decodeBase58(player)], programId)).key);

      var opponentAccount = _base58Encoder.encodeBase58(
          (await _pdaService.findProgramAddress([utf8.encode("player_account"), _base58Encoder.decodeBase58(opponent)], programId)).key);

      var gameAccount = _base58Encoder.encodeBase58(
          (await _pdaService.findProgramAddress([utf8.encode("game_account")], programId)).key);

      var engageAccount = _base58Encoder.encodeBase58(
          (await _pdaService.findProgramAddress([utf8.encode("engage_account"), _base58Encoder.decodeBase58(challenger), _base58Encoder.decodeBase58(defender)], programId)).key);

      var systemProgram = "11111111111111111111111111111111";

      var playerKeyPair = await SolanaKeyPair(
          _base58Encoder.decodeBase58(player), Uint8List.fromList(
          _base58Encoder.decodeBase58(signerSecret).take(32).toList()))
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
            player,
            playerAccount,
            opponentAccount,
            gameAccount,
            engageAccount,
            systemProgram,
            opponent,
            programId,
      ]);

      expect(
          transaction.message.instructions[0].programIdIndex, 7);

      expect(
          transaction.message.instructions[0].accountIndices,
          Uint8List.fromList([1, 2, 3, 4, 0, 6, 5]));

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
      var signerSecret = "fWPVvAFaVWzRTNKbL51mmCq2eTnbzEpNNTMkMFR3Vta6xEFZBqZg5AeXkm1ANiC4oo4PimyhVBjMuM3x96ckmon";
      var signerSecret2 = "2mDoDZb8dPzj8swAJ5uKyeHX3cm2PcNUCqQsFxTb8QQuNWoq7EC7wGVYAhfK82JSvB3V7dkTx4WyN3YPHurgDHvw";

      var player = _base58Encoder.encodeBase58(
          Uint8List.fromList(_base58Encoder.decodeBase58(signerSecret).getRange(32, 64).toList()));

      var opponent = _base58Encoder.encodeBase58(
          Uint8List.fromList(_base58Encoder.decodeBase58(signerSecret2).getRange(32, 64).toList()));

      var defender = player;
      var challenger = opponent;

      var playerAccount = _base58Encoder.encodeBase58(
          (await _pdaService.findProgramAddress([utf8.encode("player_account"), _base58Encoder.decodeBase58(player)], programId)).key);

      var opponentAccount = _base58Encoder.encodeBase58(
          (await _pdaService.findProgramAddress([utf8.encode("player_account"), _base58Encoder.decodeBase58(opponent)], programId)).key);

      var gameAccount = _base58Encoder.encodeBase58(
          (await _pdaService.findProgramAddress([utf8.encode("game_account")], programId)).key);

      var engageAccount = _base58Encoder.encodeBase58(
          (await _pdaService.findProgramAddress([utf8.encode("engage_account"), _base58Encoder.decodeBase58(challenger), _base58Encoder.decodeBase58(defender)], programId)).key);

      var systemProgram = "11111111111111111111111111111111";

      var playerKeyPair = await SolanaKeyPair(
          _base58Encoder.decodeBase58(player), Uint8List.fromList(
          _base58Encoder.decodeBase58(signerSecret).take(32).toList()))
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
            player,
            playerAccount,
            opponentAccount,
            gameAccount,
            engageAccount,
            systemProgram,
            opponent,
            programId,
      ]);

      expect(
          transaction.message.instructions[0].programIdIndex, 7);

      expect(
          transaction.message.instructions[0].accountIndices,
          Uint8List.fromList([1, 2, 3, 4, 0, 6, 5]));

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