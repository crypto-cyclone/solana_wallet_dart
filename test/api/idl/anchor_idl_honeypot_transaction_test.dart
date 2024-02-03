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
        "oK5KQvoP3Xa2FDKD6nC8BA6o3U5hEty"
        "nhT4e4M2puuoJDaEU9JZAS1AZwmBboG"
        "LbkZ8WWfc9zEhYiAynnPVsudafoH6i2"
        "veKjdotAzgKatx74MBonYNUzH9KHhi9"
        "6vLWpdYBVL9hwkZUQeVnVHryVryDStf"
        "aRwM22tZQpUmxdVJZVpSTmjoE9qx1v6"
        "bLZzepDucLdjhzmCdBKzMRA7SsYLbXj"
        "qGgLjVq3gLgcchBzUpemCLVP287YEN3"
        "ZMjQYZBUWMAWhasJvDu9fdHYBn48bkD"
        "Fu5T1gN6W6gHRqh3LNZViMwHYTM9dYW"
        "PtUdF1ZDzprUXZGLzg488hV6Ff7vYqM"
        "irRx48rpehGrMANZXkQzXtsj4arBFqu"
        "6S1Ffs9X9XWaiXU71UUr3Spef6P48Lb"
        "WNcqEpwfxZKs7U7K1zWFuy2SfdhDi7";

    const String expectPingTransaction =
        "kxDDsqSV3pV31UcZC16KYUBfc2sPpY"
        "MJPpJ7SEZ7eRwT5MdciV2zBJRFgQ4m"
        "Hr2Wevdbctp7SJwvwNFs5fKo8GLTRc"
        "aw1kivNnmPyiuja4Ftq2U4t2cbQPwd"
        "Vzv8v2cvCsgTb2wSjs8GiSL8j9x41c"
        "hfM2SXLpVR58ynf33Qtj7yLh4XLrRK"
        "LvEL19JDJhUJeqrNsuWfhxqEH3ig5t"
        "3rVAFqEGcC1NbTUTmt1SN1HFRxVW9J"
        "oivofZ5giGQSW8FqmYshckBucZ5vYe"
        "y1k6Fy6pZEaEzqzB6Kg7m22kTPVrMm"
        "LLjjjaNcs25yQU3DRYnupGc3LoYudW"
        "Ug";

    const String expectEngageTransaction =
        "rnJKb5Z5sLHj3maNySQAErxEq3WoxbBX"
        "M7QuCGzKxBdaEDqZxTgned7rPRvovwiT"
        "odsspCr2bWCSEboVTMLob7Zttt2ECzCD"
        "M9wmuQWSVtEq1AgzJKaG4r6TUMD7yWP3"
        "Xno34955RA5CrG3Ypq1m2Ychecd8FrDL"
        "ZHKRasTftnQykH5dS1Y4kPWKtgYGUyJk"
        "RigXRGk5mBMMU1BegLWa8w7HEtqFnafi"
        "Upvnn9yUqwPi25SnLdmpC7R1Adc8PPCY"
        "WLhjkLx7MtLXde82veusA2aRkbjmhnoK"
        "Wek3ud4s3tud3wvZEaA4iDwqvSVbHpZS"
        "1bYghAUAqSRcU49BJBSkeUWocYGFyex6"
        "EWYhf4WRkJ8Zq8DouHEbARkmRtwpL8E1"
        "zEX2U7jEqkgDwuuroJS1fze9ok8f3eX3"
        "LX9g6Cq6WGeHuAP2cXgj6wG1bennX7Cp"
        "df1QY3oLVtSv3P4JugR1huqYeRumB1yP"
        "UBDkNGt8E1ZZ1fX98QiQ9jTydGzyK5AC"
        "CUJ";


    const String expectPlayTransaction =
        "q6d8pnw5mcVX8UnioWBdBmPJ8JSEAr"
        "JAtc1apGTtSG526TgsBPtMnwHZRzgD"
        "6kdSWBCUmnA1RsEezVbWZHshLq5UcU"
        "6sGo3txW9fqSCm9sHg1a82yoLP9sNt"
        "aHnRuLtUxJe6cmmvUK15HtD3Fpr641"
        "yjYHmgZpjpvehug7F7rgDLXRrQKhtn"
        "aKJDLKadghsVWiroSc1THChaveLCPH"
        "Sme5eQNBZxA9C9VnutWrtY2pJgmExX"
        "gVhiAYARrUvucQvcbr6YXmZeEGtYda"
        "RsF9a9CKjGAbJw7iM1P3RDhn7brnAp"
        "Xyzd13r3hhyoB1banH5YniFi7pWhh1"
        "7fgbfWNAyJYfTg3NwtAoQxyiZbPpuM"
        "mJo1uMoZ1hMGqaYfAiaz6y2qX3arZs"
        "js9FujdyjvZMmx2nQ1eKJeR6oCAYqE"
        "MSXmUgDAxCKmaFL4afH2ZyuaFgZVBa"
        "NrbQf6TG1fQNnRR4SwB4cAcykD5KvD"
        "8pByzN3pcKYoRacg4pc9rdA3KoLMSX"
        "mDVxEJFUAE2SGsJyT2YDyJPPUMtYkk"
        "ATEJX8wAzT4PfaVn";

    const String expectRevealTransaction =
        "5TToEQHPJEA9FSKvEEGZsusCvSZkdY3"
        "oDMxEWMeBdnCneojznxHv7YpULqr1Qq"
        "4XRwWokATtyz9GA5jRZTnKVjCsKs3k8"
        "eaP8HXx54A5kTVSXnjE4uXaPf1egMep"
        "nozFLztvH8tJihF45YDd7h1ZRempby8"
        "JJfRC5NZHXUzc8WMF4s59GAwxMentBU"
        "bCGZE2KE5pp7mtvdUMm9v5cLNQCT62j"
        "wMwtknZRGokbUTeGbgmGyZMzs5wW1LE"
        "hbBARg9RPn9xUxV6UxfmVAbzzxLorD3"
        "8gWh3gLaudnBqU352RTDzSMWwskTNFW"
        "M2yDdp6XsCQTa7pgjQVnWyJeNC6uE1z"
        "5wC37FUP2HEZdrSvV1VpRU3aofvPtP5"
        "rTawPmNEQQZK2VB6iQtGwuPzzNp8oyv"
        "vWENLiiNZVYSU8HfZ5TQSReeUEgtnEd"
        "4GntcGkah7LsNPnmJi7WxZz8vSHopZw"
        "r7graC9vG1qXUxPM2YW5yAAAuvw2hag"
        "nvh2Nu7AJMTMi7SotLaYz3hPRFZGZhf"
        "9nppCM8JX";

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
      expect(transaction.message.instructions[0].programIdIndex, 5);
      expect(transaction.message.accountAddresses, [
        player,
        gameAccount,
        playerAccount,
        systemProgram,
        recentSlotHashes,
        programId,
      ]);
      expect(transaction.message.instructions[0].accountIndices,
          Uint8List.fromList([2, 1, 0, 3, 4]));

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
          gameAccount,
          playerAccount,
          programId
      ]);

      expect(
          transaction.message.instructions[0].accountIndices,
          Uint8List.fromList([2, 1, 0]));

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
          .withArgs(3)
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
            engageAccount,
            challengerAccount,
            gameAccount,
            defenderAccount,
            systemProgram,
            challenger,
            programId,
      ]);

      expect(
          transaction.message.instructions[0].programIdIndex, 7);

      expect(
          transaction.message.instructions[0].accountIndices,
          Uint8List.fromList([2, 4, 3, 1, 0, 6, 0, 5]));

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
            engageAccount,
            opponentAccount,
            gameAccount,
            playerAccount,
            systemProgram,
            opponent,
            programId,
      ]);

      expect(
          transaction.message.instructions[0].programIdIndex, 7);

      expect(
          transaction.message.instructions[0].accountIndices,
          Uint8List.fromList([4, 2, 3, 1, 0, 6, 5]));

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
            engageAccount,
            opponentAccount,
            gameAccount,
            playerAccount,
            systemProgram,
            opponent,
            programId,
      ]);

      expect(
          transaction.message.instructions[0].programIdIndex, 7);

      expect(
          transaction.message.instructions[0].accountIndices,
          Uint8List.fromList([4, 2, 3, 1, 0, 6, 5]));

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