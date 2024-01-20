import 'dart:typed_data';
 
import 'package:solana_wallet/api/idl/anchor_idl.dart';
import 'package:solana_wallet/api/idl/anchor_idl_serialization_registry.dart';

class HoneypotAnchorIDL extends AnchorIDL {
  final HoneypotLoginInstruction loginInstruction;
  final HoneypotPingInstruction pingInstruction;
  final HoneypotEngageInstruction engageInstruction;
  final HoneypotPlayInstruction playInstruction;
  final HoneypotRevealInstruction revealInstruction;
  final HoneypotDrainPlayerInstruction drainPlayerInstruction;
  final HoneypotDrainGameInstruction drainGameInstruction;
  final HoneypotPlayerAccount playerAccount;
  final HoneypotGameAccount gameAccount;
  final HoneypotEngageAccount engageAccount;
  
  HoneypotAnchorIDL()
    : loginInstruction = HoneypotLoginInstruction(),
      pingInstruction = HoneypotPingInstruction(),
      engageInstruction = HoneypotEngageInstruction(),
      playInstruction = HoneypotPlayInstruction(),
      revealInstruction = HoneypotRevealInstruction(),
      drainPlayerInstruction = HoneypotDrainPlayerInstruction(),
      drainGameInstruction = HoneypotDrainGameInstruction(),
      playerAccount = HoneypotPlayerAccount(),
      gameAccount = HoneypotGameAccount(),
      engageAccount = HoneypotEngageAccount(),
      super(
          version: '0.1.0',
          name: 'honeypot',
          metadata: AnchorMetadata(address: '6WE2EY62Pca64J2gLsiAHgHWSXz3EB1szZe5iaZVmp9s')) {
        initialize();
      }

  void initialize() {
      serializationRegistry.register<AnchorFieldArray<AnchorFieldU8>>(() => AnchorFieldArray.factory<AnchorFieldU8>(8));
      serializationRegistry.register<AnchorFieldStruct<HoneypotSealedMoveStruct>>(() => AnchorFieldStruct.factory<HoneypotSealedMoveStruct>());
      serializationRegistry.register<AnchorFieldStruct<HoneypotRevealedMoveStruct>>(() => AnchorFieldStruct.factory<HoneypotRevealedMoveStruct>());
      serializationRegistry.register<AnchorFieldPublicKey>(() => AnchorFieldPublicKey.factory());
      serializationRegistry.register<AnchorFieldArray<AnchorFieldU8>>(() => AnchorFieldArray.factory<AnchorFieldU8>(32));
      serializationRegistry.register<AnchorFieldU64>(() => AnchorFieldU64.factory());
      serializationRegistry.register<AnchorFieldU8>(() => AnchorFieldU8.factory());
      serializationRegistry.register<AnchorFieldI64>(() => AnchorFieldI64.factory());
      serializationRegistry.register<AnchorFieldEnum<HoneypotPlayerStateEnum>>(() => AnchorFieldEnum.factory<HoneypotPlayerStateEnum>());
      serializationRegistry.register<AnchorFieldEnum<HoneypotGameStateEnum>>(() => AnchorFieldEnum.factory<HoneypotGameStateEnum>());
      serializationRegistry.register<AnchorFieldEnum<HoneypotMoveTypeEnum>>(() => AnchorFieldEnum.factory<HoneypotMoveTypeEnum>());
      serializationRegistry.register<AnchorFieldEnum<HoneypotEngageResultEnum>>(() => AnchorFieldEnum.factory<HoneypotEngageResultEnum>());
      serializationRegistry.register<HoneypotSealedMoveStruct>(() => HoneypotSealedMoveStruct());
      serializationRegistry.register<HoneypotRevealedMoveStruct>(() => HoneypotRevealedMoveStruct());
      serializationRegistry.register<HoneypotEngageResultEnum>(() => HoneypotEngageResultEnum.values.first);
      serializationRegistry.register<HoneypotPlayerStateEnum>(() => HoneypotPlayerStateEnum.values.first);
      serializationRegistry.register<HoneypotMoveTypeEnum>(() => HoneypotMoveTypeEnum.values.first);
      serializationRegistry.register<HoneypotGameStateEnum>(() => HoneypotGameStateEnum.values.first);
      serializationRegistry.register<AnchorFieldString>(() => AnchorFieldString.factory());
  }

}

class HoneypotLoginInstruction extends AnchorInstruction {
  final AnchorFieldArray<AnchorFieldU8> seedField;
  final AnchorInstructionAccount playerAccountAccount;
  final AnchorInstructionAccount gameAccountAccount;
  final AnchorInstructionAccount playerAccount;
  final AnchorInstructionAccount systemProgramAccount;
  final AnchorInstructionAccount recentSlotHashesAccount;

    HoneypotLoginInstruction()
      : seedField = AnchorFieldArray<AnchorFieldU8>(value: []),
        playerAccountAccount = AnchorInstructionAccount(name: 'playerAccount', isMut: true, isSigner: false, address: '', index: 0),
        gameAccountAccount = AnchorInstructionAccount(name: 'gameAccount', isMut: true, isSigner: false, address: '', index: 1),
        playerAccount = AnchorInstructionAccount(name: 'player', isMut: true, isSigner: true, address: '', index: 2),
        systemProgramAccount = AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: '', index: 3),
        recentSlotHashesAccount = AnchorInstructionAccount(name: 'recentSlotHashes', isMut: false, isSigner: false, address: '', index: 4),
      super(
          name: 'login',
          args: {
            'seed': AnchorFieldArray<AnchorFieldU8>(value: [])},
          accounts: {
            'playerAccount': AnchorInstructionAccount(name: 'playerAccount', isMut: true, isSigner: false, address: '', index: 0),
            'gameAccount': AnchorInstructionAccount(name: 'gameAccount', isMut: true, isSigner: false, address: '', index: 1),
            'player': AnchorInstructionAccount(name: 'player', isMut: true, isSigner: true, address: '', index: 2),
            'systemProgram': AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: '', index: 3),
            'recentSlotHashes': AnchorInstructionAccount(name: 'recentSlotHashes', isMut: false, isSigner: false, address: '', index: 4)});
  
    HoneypotLoginInstruction withArgs(List<int> seed) {
      return HoneypotLoginInstruction._withAll(
        seed,
        playerAccountAccount.address, gameAccountAccount.address, playerAccount.address, systemProgramAccount.address, recentSlotHashesAccount.address,
        true,
        accountsSet
      );
    }
  
    HoneypotLoginInstruction withAccounts(String playerAccount, String gameAccount, String player, String systemProgram, String recentSlotHashes) {
      return HoneypotLoginInstruction._withAll(
        seedField.dartValue().map((e) => e as int).toList(),
        playerAccount, gameAccount, player, systemProgram, recentSlotHashes,
        argsSet,
        true
      );
    }
  
    HoneypotLoginInstruction._withAll(List<int> seed, String playerAccount, String gameAccount, String player, String systemProgram, String recentSlotHashes, bool argsSet, bool accountsSet)
      : seedField = AnchorFieldArray<AnchorFieldU8>(value: seed.map((e) => AnchorFieldU8(value: e)).toList()),
        playerAccountAccount = AnchorInstructionAccount(name: 'playerAccount', isMut: true, isSigner: false, address: playerAccount, index: 0),
        gameAccountAccount = AnchorInstructionAccount(name: 'gameAccount', isMut: true, isSigner: false, address: gameAccount, index: 1),
        playerAccount = AnchorInstructionAccount(name: 'player', isMut: true, isSigner: true, address: player, index: 2),
        systemProgramAccount = AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: systemProgram, index: 3),
        recentSlotHashesAccount = AnchorInstructionAccount(name: 'recentSlotHashes', isMut: false, isSigner: false, address: recentSlotHashes, index: 4),
        super(
          name: 'login',
          args: {
            'seed': AnchorFieldArray<AnchorFieldU8>(value: seed.map((e) => AnchorFieldU8(value: e)).toList())},
          accounts: {
            'playerAccount': AnchorInstructionAccount(name: 'playerAccount', isMut: true, isSigner: false, address: playerAccount, index: 0),
            'gameAccount': AnchorInstructionAccount(name: 'gameAccount', isMut: true, isSigner: false, address: gameAccount, index: 1),
            'player': AnchorInstructionAccount(name: 'player', isMut: true, isSigner: true, address: player, index: 2),
            'systemProgram': AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: systemProgram, index: 3),
            'recentSlotHashes': AnchorInstructionAccount(name: 'recentSlotHashes', isMut: false, isSigner: false, address: recentSlotHashes, index: 4)},
          argsSet: argsSet,
          accountsSet: accountsSet);
  
}

class HoneypotPingInstruction extends AnchorInstruction {
  final AnchorInstructionAccount playerAccountAccount;
  final AnchorInstructionAccount gameAccountAccount;
  final AnchorInstructionAccount playerAccount;

    HoneypotPingInstruction()
      : playerAccountAccount = AnchorInstructionAccount(name: 'playerAccount', isMut: true, isSigner: false, address: '', index: 0),
        gameAccountAccount = AnchorInstructionAccount(name: 'gameAccount', isMut: true, isSigner: false, address: '', index: 1),
        playerAccount = AnchorInstructionAccount(name: 'player', isMut: true, isSigner: true, address: '', index: 2),
      super(
          name: 'ping',
          args: {
            },
          accounts: {
            'playerAccount': AnchorInstructionAccount(name: 'playerAccount', isMut: true, isSigner: false, address: '', index: 0),
            'gameAccount': AnchorInstructionAccount(name: 'gameAccount', isMut: true, isSigner: false, address: '', index: 1),
            'player': AnchorInstructionAccount(name: 'player', isMut: true, isSigner: true, address: '', index: 2)});
  
    HoneypotPingInstruction withArgs() {
      return HoneypotPingInstruction._withAll(
        
        playerAccountAccount.address, gameAccountAccount.address, playerAccount.address,
        true,
        accountsSet
      );
    }
  
    HoneypotPingInstruction withAccounts(String playerAccount, String gameAccount, String player) {
      return HoneypotPingInstruction._withAll(
        
        playerAccount, gameAccount, player,
        argsSet,
        true
      );
    }
  
    HoneypotPingInstruction._withAll(String playerAccount, String gameAccount, String player, bool argsSet, bool accountsSet)
      : playerAccountAccount = AnchorInstructionAccount(name: 'playerAccount', isMut: true, isSigner: false, address: playerAccount, index: 0),
        gameAccountAccount = AnchorInstructionAccount(name: 'gameAccount', isMut: true, isSigner: false, address: gameAccount, index: 1),
        playerAccount = AnchorInstructionAccount(name: 'player', isMut: true, isSigner: true, address: player, index: 2),
        super(
          name: 'ping',
          args: {
            },
          accounts: {
            'playerAccount': AnchorInstructionAccount(name: 'playerAccount', isMut: true, isSigner: false, address: playerAccount, index: 0),
            'gameAccount': AnchorInstructionAccount(name: 'gameAccount', isMut: true, isSigner: false, address: gameAccount, index: 1),
            'player': AnchorInstructionAccount(name: 'player', isMut: true, isSigner: true, address: player, index: 2)},
          argsSet: argsSet,
          accountsSet: accountsSet);
  
}

class HoneypotEngageInstruction extends AnchorInstruction {
  final AnchorInstructionAccount challengerAccountAccount;
  final AnchorInstructionAccount defenderAccountAccount;
  final AnchorInstructionAccount gameAccountAccount;
  final AnchorInstructionAccount engageAccountAccount;
  final AnchorInstructionAccount playerAccount;
  final AnchorInstructionAccount challengerAccount;
  final AnchorInstructionAccount defenderAccount;
  final AnchorInstructionAccount systemProgramAccount;

    HoneypotEngageInstruction()
      : challengerAccountAccount = AnchorInstructionAccount(name: 'challengerAccount', isMut: true, isSigner: false, address: '', index: 0),
        defenderAccountAccount = AnchorInstructionAccount(name: 'defenderAccount', isMut: true, isSigner: false, address: '', index: 1),
        gameAccountAccount = AnchorInstructionAccount(name: 'gameAccount', isMut: true, isSigner: false, address: '', index: 2),
        engageAccountAccount = AnchorInstructionAccount(name: 'engageAccount', isMut: true, isSigner: false, address: '', index: 3),
        playerAccount = AnchorInstructionAccount(name: 'player', isMut: true, isSigner: true, address: '', index: 4),
        challengerAccount = AnchorInstructionAccount(name: 'challenger', isMut: false, isSigner: false, address: '', index: 5),
        defenderAccount = AnchorInstructionAccount(name: 'defender', isMut: false, isSigner: false, address: '', index: 6),
        systemProgramAccount = AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: '', index: 7),
      super(
          name: 'engage',
          args: {
            },
          accounts: {
            'challengerAccount': AnchorInstructionAccount(name: 'challengerAccount', isMut: true, isSigner: false, address: '', index: 0),
            'defenderAccount': AnchorInstructionAccount(name: 'defenderAccount', isMut: true, isSigner: false, address: '', index: 1),
            'gameAccount': AnchorInstructionAccount(name: 'gameAccount', isMut: true, isSigner: false, address: '', index: 2),
            'engageAccount': AnchorInstructionAccount(name: 'engageAccount', isMut: true, isSigner: false, address: '', index: 3),
            'player': AnchorInstructionAccount(name: 'player', isMut: true, isSigner: true, address: '', index: 4),
            'challenger': AnchorInstructionAccount(name: 'challenger', isMut: false, isSigner: false, address: '', index: 5),
            'defender': AnchorInstructionAccount(name: 'defender', isMut: false, isSigner: false, address: '', index: 6),
            'systemProgram': AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: '', index: 7)});
  
    HoneypotEngageInstruction withArgs() {
      return HoneypotEngageInstruction._withAll(
        
        challengerAccountAccount.address, defenderAccountAccount.address, gameAccountAccount.address, engageAccountAccount.address, playerAccount.address, challengerAccount.address, defenderAccount.address, systemProgramAccount.address,
        true,
        accountsSet
      );
    }
  
    HoneypotEngageInstruction withAccounts(String challengerAccount, String defenderAccount, String gameAccount, String engageAccount, String player, String challenger, String defender, String systemProgram) {
      return HoneypotEngageInstruction._withAll(
        
        challengerAccount, defenderAccount, gameAccount, engageAccount, player, challenger, defender, systemProgram,
        argsSet,
        true
      );
    }
  
    HoneypotEngageInstruction._withAll(String challengerAccount, String defenderAccount, String gameAccount, String engageAccount, String player, String challenger, String defender, String systemProgram, bool argsSet, bool accountsSet)
      : challengerAccountAccount = AnchorInstructionAccount(name: 'challengerAccount', isMut: true, isSigner: false, address: challengerAccount, index: 0),
        defenderAccountAccount = AnchorInstructionAccount(name: 'defenderAccount', isMut: true, isSigner: false, address: defenderAccount, index: 1),
        gameAccountAccount = AnchorInstructionAccount(name: 'gameAccount', isMut: true, isSigner: false, address: gameAccount, index: 2),
        engageAccountAccount = AnchorInstructionAccount(name: 'engageAccount', isMut: true, isSigner: false, address: engageAccount, index: 3),
        playerAccount = AnchorInstructionAccount(name: 'player', isMut: true, isSigner: true, address: player, index: 4),
        challengerAccount = AnchorInstructionAccount(name: 'challenger', isMut: false, isSigner: false, address: challenger, index: 5),
        defenderAccount = AnchorInstructionAccount(name: 'defender', isMut: false, isSigner: false, address: defender, index: 6),
        systemProgramAccount = AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: systemProgram, index: 7),
        super(
          name: 'engage',
          args: {
            },
          accounts: {
            'challengerAccount': AnchorInstructionAccount(name: 'challengerAccount', isMut: true, isSigner: false, address: challengerAccount, index: 0),
            'defenderAccount': AnchorInstructionAccount(name: 'defenderAccount', isMut: true, isSigner: false, address: defenderAccount, index: 1),
            'gameAccount': AnchorInstructionAccount(name: 'gameAccount', isMut: true, isSigner: false, address: gameAccount, index: 2),
            'engageAccount': AnchorInstructionAccount(name: 'engageAccount', isMut: true, isSigner: false, address: engageAccount, index: 3),
            'player': AnchorInstructionAccount(name: 'player', isMut: true, isSigner: true, address: player, index: 4),
            'challenger': AnchorInstructionAccount(name: 'challenger', isMut: false, isSigner: false, address: challenger, index: 5),
            'defender': AnchorInstructionAccount(name: 'defender', isMut: false, isSigner: false, address: defender, index: 6),
            'systemProgram': AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: systemProgram, index: 7)},
          argsSet: argsSet,
          accountsSet: accountsSet);
  
}

class HoneypotPlayInstruction extends AnchorInstruction {
  final AnchorFieldStruct<HoneypotSealedMoveStruct> sealedMoveField;
  final AnchorInstructionAccount playerAccountAccount;
  final AnchorInstructionAccount opponentAccountAccount;
  final AnchorInstructionAccount gameAccountAccount;
  final AnchorInstructionAccount engageAccountAccount;
  final AnchorInstructionAccount playerAccount;
  final AnchorInstructionAccount opponentAccount;
  final AnchorInstructionAccount systemProgramAccount;

    HoneypotPlayInstruction()
      : sealedMoveField = AnchorFieldStruct<HoneypotSealedMoveStruct>(value: HoneypotSealedMoveStruct.factory()),
        playerAccountAccount = AnchorInstructionAccount(name: 'playerAccount', isMut: true, isSigner: false, address: '', index: 0),
        opponentAccountAccount = AnchorInstructionAccount(name: 'opponentAccount', isMut: true, isSigner: false, address: '', index: 1),
        gameAccountAccount = AnchorInstructionAccount(name: 'gameAccount', isMut: true, isSigner: false, address: '', index: 2),
        engageAccountAccount = AnchorInstructionAccount(name: 'engageAccount', isMut: true, isSigner: false, address: '', index: 3),
        playerAccount = AnchorInstructionAccount(name: 'player', isMut: true, isSigner: true, address: '', index: 4),
        opponentAccount = AnchorInstructionAccount(name: 'opponent', isMut: false, isSigner: false, address: '', index: 5),
        systemProgramAccount = AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: '', index: 6),
      super(
          name: 'play',
          args: {
            'sealedMove': AnchorFieldStruct<HoneypotSealedMoveStruct>(value: HoneypotSealedMoveStruct.factory())},
          accounts: {
            'playerAccount': AnchorInstructionAccount(name: 'playerAccount', isMut: true, isSigner: false, address: '', index: 0),
            'opponentAccount': AnchorInstructionAccount(name: 'opponentAccount', isMut: true, isSigner: false, address: '', index: 1),
            'gameAccount': AnchorInstructionAccount(name: 'gameAccount', isMut: true, isSigner: false, address: '', index: 2),
            'engageAccount': AnchorInstructionAccount(name: 'engageAccount', isMut: true, isSigner: false, address: '', index: 3),
            'player': AnchorInstructionAccount(name: 'player', isMut: true, isSigner: true, address: '', index: 4),
            'opponent': AnchorInstructionAccount(name: 'opponent', isMut: false, isSigner: false, address: '', index: 5),
            'systemProgram': AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: '', index: 6)});
  
    HoneypotPlayInstruction withArgs(HoneypotSealedMoveStruct sealedMove) {
      return HoneypotPlayInstruction._withAll(
        sealedMove,
        playerAccountAccount.address, opponentAccountAccount.address, gameAccountAccount.address, engageAccountAccount.address, playerAccount.address, opponentAccount.address, systemProgramAccount.address,
        true,
        accountsSet
      );
    }
  
    HoneypotPlayInstruction withAccounts(String playerAccount, String opponentAccount, String gameAccount, String engageAccount, String player, String opponent, String systemProgram) {
      return HoneypotPlayInstruction._withAll(
        sealedMoveField.dartValue(),
        playerAccount, opponentAccount, gameAccount, engageAccount, player, opponent, systemProgram,
        argsSet,
        true
      );
    }
  
    HoneypotPlayInstruction._withAll(HoneypotSealedMoveStruct sealedMove, String playerAccount, String opponentAccount, String gameAccount, String engageAccount, String player, String opponent, String systemProgram, bool argsSet, bool accountsSet)
      : sealedMoveField = AnchorFieldStruct<HoneypotSealedMoveStruct>(value: sealedMove),
        playerAccountAccount = AnchorInstructionAccount(name: 'playerAccount', isMut: true, isSigner: false, address: playerAccount, index: 0),
        opponentAccountAccount = AnchorInstructionAccount(name: 'opponentAccount', isMut: true, isSigner: false, address: opponentAccount, index: 1),
        gameAccountAccount = AnchorInstructionAccount(name: 'gameAccount', isMut: true, isSigner: false, address: gameAccount, index: 2),
        engageAccountAccount = AnchorInstructionAccount(name: 'engageAccount', isMut: true, isSigner: false, address: engageAccount, index: 3),
        playerAccount = AnchorInstructionAccount(name: 'player', isMut: true, isSigner: true, address: player, index: 4),
        opponentAccount = AnchorInstructionAccount(name: 'opponent', isMut: false, isSigner: false, address: opponent, index: 5),
        systemProgramAccount = AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: systemProgram, index: 6),
        super(
          name: 'play',
          args: {
            'sealedMove': AnchorFieldStruct<HoneypotSealedMoveStruct>(value: sealedMove)},
          accounts: {
            'playerAccount': AnchorInstructionAccount(name: 'playerAccount', isMut: true, isSigner: false, address: playerAccount, index: 0),
            'opponentAccount': AnchorInstructionAccount(name: 'opponentAccount', isMut: true, isSigner: false, address: opponentAccount, index: 1),
            'gameAccount': AnchorInstructionAccount(name: 'gameAccount', isMut: true, isSigner: false, address: gameAccount, index: 2),
            'engageAccount': AnchorInstructionAccount(name: 'engageAccount', isMut: true, isSigner: false, address: engageAccount, index: 3),
            'player': AnchorInstructionAccount(name: 'player', isMut: true, isSigner: true, address: player, index: 4),
            'opponent': AnchorInstructionAccount(name: 'opponent', isMut: false, isSigner: false, address: opponent, index: 5),
            'systemProgram': AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: systemProgram, index: 6)},
          argsSet: argsSet,
          accountsSet: accountsSet);
  
}

class HoneypotRevealInstruction extends AnchorInstruction {
  final AnchorFieldStruct<HoneypotRevealedMoveStruct> revealedMoveField;
  final AnchorInstructionAccount playerAccountAccount;
  final AnchorInstructionAccount opponentAccountAccount;
  final AnchorInstructionAccount gameAccountAccount;
  final AnchorInstructionAccount engageAccountAccount;
  final AnchorInstructionAccount playerAccount;
  final AnchorInstructionAccount opponentAccount;
  final AnchorInstructionAccount systemProgramAccount;

    HoneypotRevealInstruction()
      : revealedMoveField = AnchorFieldStruct<HoneypotRevealedMoveStruct>(value: HoneypotRevealedMoveStruct.factory()),
        playerAccountAccount = AnchorInstructionAccount(name: 'playerAccount', isMut: true, isSigner: false, address: '', index: 0),
        opponentAccountAccount = AnchorInstructionAccount(name: 'opponentAccount', isMut: true, isSigner: false, address: '', index: 1),
        gameAccountAccount = AnchorInstructionAccount(name: 'gameAccount', isMut: true, isSigner: false, address: '', index: 2),
        engageAccountAccount = AnchorInstructionAccount(name: 'engageAccount', isMut: true, isSigner: false, address: '', index: 3),
        playerAccount = AnchorInstructionAccount(name: 'player', isMut: true, isSigner: true, address: '', index: 4),
        opponentAccount = AnchorInstructionAccount(name: 'opponent', isMut: false, isSigner: false, address: '', index: 5),
        systemProgramAccount = AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: '', index: 6),
      super(
          name: 'reveal',
          args: {
            'revealedMove': AnchorFieldStruct<HoneypotRevealedMoveStruct>(value: HoneypotRevealedMoveStruct.factory())},
          accounts: {
            'playerAccount': AnchorInstructionAccount(name: 'playerAccount', isMut: true, isSigner: false, address: '', index: 0),
            'opponentAccount': AnchorInstructionAccount(name: 'opponentAccount', isMut: true, isSigner: false, address: '', index: 1),
            'gameAccount': AnchorInstructionAccount(name: 'gameAccount', isMut: true, isSigner: false, address: '', index: 2),
            'engageAccount': AnchorInstructionAccount(name: 'engageAccount', isMut: true, isSigner: false, address: '', index: 3),
            'player': AnchorInstructionAccount(name: 'player', isMut: true, isSigner: true, address: '', index: 4),
            'opponent': AnchorInstructionAccount(name: 'opponent', isMut: false, isSigner: false, address: '', index: 5),
            'systemProgram': AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: '', index: 6)});
  
    HoneypotRevealInstruction withArgs(HoneypotRevealedMoveStruct revealedMove) {
      return HoneypotRevealInstruction._withAll(
        revealedMove,
        playerAccountAccount.address, opponentAccountAccount.address, gameAccountAccount.address, engageAccountAccount.address, playerAccount.address, opponentAccount.address, systemProgramAccount.address,
        true,
        accountsSet
      );
    }
  
    HoneypotRevealInstruction withAccounts(String playerAccount, String opponentAccount, String gameAccount, String engageAccount, String player, String opponent, String systemProgram) {
      return HoneypotRevealInstruction._withAll(
        revealedMoveField.dartValue(),
        playerAccount, opponentAccount, gameAccount, engageAccount, player, opponent, systemProgram,
        argsSet,
        true
      );
    }
  
    HoneypotRevealInstruction._withAll(HoneypotRevealedMoveStruct revealedMove, String playerAccount, String opponentAccount, String gameAccount, String engageAccount, String player, String opponent, String systemProgram, bool argsSet, bool accountsSet)
      : revealedMoveField = AnchorFieldStruct<HoneypotRevealedMoveStruct>(value: revealedMove),
        playerAccountAccount = AnchorInstructionAccount(name: 'playerAccount', isMut: true, isSigner: false, address: playerAccount, index: 0),
        opponentAccountAccount = AnchorInstructionAccount(name: 'opponentAccount', isMut: true, isSigner: false, address: opponentAccount, index: 1),
        gameAccountAccount = AnchorInstructionAccount(name: 'gameAccount', isMut: true, isSigner: false, address: gameAccount, index: 2),
        engageAccountAccount = AnchorInstructionAccount(name: 'engageAccount', isMut: true, isSigner: false, address: engageAccount, index: 3),
        playerAccount = AnchorInstructionAccount(name: 'player', isMut: true, isSigner: true, address: player, index: 4),
        opponentAccount = AnchorInstructionAccount(name: 'opponent', isMut: false, isSigner: false, address: opponent, index: 5),
        systemProgramAccount = AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: systemProgram, index: 6),
        super(
          name: 'reveal',
          args: {
            'revealedMove': AnchorFieldStruct<HoneypotRevealedMoveStruct>(value: revealedMove)},
          accounts: {
            'playerAccount': AnchorInstructionAccount(name: 'playerAccount', isMut: true, isSigner: false, address: playerAccount, index: 0),
            'opponentAccount': AnchorInstructionAccount(name: 'opponentAccount', isMut: true, isSigner: false, address: opponentAccount, index: 1),
            'gameAccount': AnchorInstructionAccount(name: 'gameAccount', isMut: true, isSigner: false, address: gameAccount, index: 2),
            'engageAccount': AnchorInstructionAccount(name: 'engageAccount', isMut: true, isSigner: false, address: engageAccount, index: 3),
            'player': AnchorInstructionAccount(name: 'player', isMut: true, isSigner: true, address: player, index: 4),
            'opponent': AnchorInstructionAccount(name: 'opponent', isMut: false, isSigner: false, address: opponent, index: 5),
            'systemProgram': AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: systemProgram, index: 6)},
          argsSet: argsSet,
          accountsSet: accountsSet);
  
}

class HoneypotDrainPlayerInstruction extends AnchorInstruction {
  final AnchorInstructionAccount playerAccountAccount;
  final AnchorInstructionAccount gameAccountAccount;
  final AnchorInstructionAccount playerAccount;
  final AnchorInstructionAccount systemProgramAccount;

    HoneypotDrainPlayerInstruction()
      : playerAccountAccount = AnchorInstructionAccount(name: 'playerAccount', isMut: true, isSigner: false, address: '', index: 0),
        gameAccountAccount = AnchorInstructionAccount(name: 'gameAccount', isMut: true, isSigner: false, address: '', index: 1),
        playerAccount = AnchorInstructionAccount(name: 'player', isMut: true, isSigner: true, address: '', index: 2),
        systemProgramAccount = AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: '', index: 3),
      super(
          name: 'drainPlayer',
          args: {
            },
          accounts: {
            'playerAccount': AnchorInstructionAccount(name: 'playerAccount', isMut: true, isSigner: false, address: '', index: 0),
            'gameAccount': AnchorInstructionAccount(name: 'gameAccount', isMut: true, isSigner: false, address: '', index: 1),
            'player': AnchorInstructionAccount(name: 'player', isMut: true, isSigner: true, address: '', index: 2),
            'systemProgram': AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: '', index: 3)});
  
    HoneypotDrainPlayerInstruction withArgs() {
      return HoneypotDrainPlayerInstruction._withAll(
        
        playerAccountAccount.address, gameAccountAccount.address, playerAccount.address, systemProgramAccount.address,
        true,
        accountsSet
      );
    }
  
    HoneypotDrainPlayerInstruction withAccounts(String playerAccount, String gameAccount, String player, String systemProgram) {
      return HoneypotDrainPlayerInstruction._withAll(
        
        playerAccount, gameAccount, player, systemProgram,
        argsSet,
        true
      );
    }
  
    HoneypotDrainPlayerInstruction._withAll(String playerAccount, String gameAccount, String player, String systemProgram, bool argsSet, bool accountsSet)
      : playerAccountAccount = AnchorInstructionAccount(name: 'playerAccount', isMut: true, isSigner: false, address: playerAccount, index: 0),
        gameAccountAccount = AnchorInstructionAccount(name: 'gameAccount', isMut: true, isSigner: false, address: gameAccount, index: 1),
        playerAccount = AnchorInstructionAccount(name: 'player', isMut: true, isSigner: true, address: player, index: 2),
        systemProgramAccount = AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: systemProgram, index: 3),
        super(
          name: 'drainPlayer',
          args: {
            },
          accounts: {
            'playerAccount': AnchorInstructionAccount(name: 'playerAccount', isMut: true, isSigner: false, address: playerAccount, index: 0),
            'gameAccount': AnchorInstructionAccount(name: 'gameAccount', isMut: true, isSigner: false, address: gameAccount, index: 1),
            'player': AnchorInstructionAccount(name: 'player', isMut: true, isSigner: true, address: player, index: 2),
            'systemProgram': AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: systemProgram, index: 3)},
          argsSet: argsSet,
          accountsSet: accountsSet);
  
}

class HoneypotDrainGameInstruction extends AnchorInstruction {
  final AnchorInstructionAccount gameAccountAccount;
  final AnchorInstructionAccount creatorAccount;

    HoneypotDrainGameInstruction()
      : gameAccountAccount = AnchorInstructionAccount(name: 'gameAccount', isMut: true, isSigner: false, address: '', index: 0),
        creatorAccount = AnchorInstructionAccount(name: 'creator', isMut: true, isSigner: true, address: '', index: 1),
      super(
          name: 'drainGame',
          args: {
            },
          accounts: {
            'gameAccount': AnchorInstructionAccount(name: 'gameAccount', isMut: true, isSigner: false, address: '', index: 0),
            'creator': AnchorInstructionAccount(name: 'creator', isMut: true, isSigner: true, address: '', index: 1)});
  
    HoneypotDrainGameInstruction withArgs() {
      return HoneypotDrainGameInstruction._withAll(
        
        gameAccountAccount.address, creatorAccount.address,
        true,
        accountsSet
      );
    }
  
    HoneypotDrainGameInstruction withAccounts(String gameAccount, String creator) {
      return HoneypotDrainGameInstruction._withAll(
        
        gameAccount, creator,
        argsSet,
        true
      );
    }
  
    HoneypotDrainGameInstruction._withAll(String gameAccount, String creator, bool argsSet, bool accountsSet)
      : gameAccountAccount = AnchorInstructionAccount(name: 'gameAccount', isMut: true, isSigner: false, address: gameAccount, index: 0),
        creatorAccount = AnchorInstructionAccount(name: 'creator', isMut: true, isSigner: true, address: creator, index: 1),
        super(
          name: 'drainGame',
          args: {
            },
          accounts: {
            'gameAccount': AnchorInstructionAccount(name: 'gameAccount', isMut: true, isSigner: false, address: gameAccount, index: 0),
            'creator': AnchorInstructionAccount(name: 'creator', isMut: true, isSigner: true, address: creator, index: 1)},
          argsSet: argsSet,
          accountsSet: accountsSet);
  
}

class HoneypotPlayerAccount extends AnchorAccount {
  final AnchorFieldPublicKey pubkeyField;
  final AnchorFieldArray<AnchorFieldU8> seedField;
  final AnchorFieldArray<AnchorFieldU8> gameIdField;
  final AnchorFieldU64 lamportsField;
  final AnchorFieldU8 bumpField;
  final AnchorFieldI64 lastSeenField;
  final AnchorFieldEnum<HoneypotPlayerStateEnum> stateField;
  final AnchorFieldPublicKey engageAccountField;
  
    HoneypotPlayerAccount()
      : pubkeyField = AnchorFieldPublicKey(value: Uint8List(0)),
        seedField = AnchorFieldArray<AnchorFieldU8>(value: [], size: 8),
        gameIdField = AnchorFieldArray<AnchorFieldU8>(value: [], size: 32),
        lamportsField = AnchorFieldU64(value: 0),
        bumpField = AnchorFieldU8(value: 0),
        lastSeenField = AnchorFieldI64(value: 0),
        stateField = AnchorFieldEnum<HoneypotPlayerStateEnum>(value: HoneypotPlayerStateEnum.values.first),
        engageAccountField = AnchorFieldPublicKey(value: Uint8List(0)),
      super(
          name: 'Player',
          fields: {
            'pubkey': AnchorFieldPublicKey(value: Uint8List(0)),
            'seed': AnchorFieldArray<AnchorFieldU8>(value: [], size: 8),
            'gameId': AnchorFieldArray<AnchorFieldU8>(value: [], size: 32),
            'lamports': AnchorFieldU64(value: 0),
            'bump': AnchorFieldU8(value: 0),
            'lastSeen': AnchorFieldI64(value: 0),
            'state': AnchorFieldEnum<HoneypotPlayerStateEnum>(value: HoneypotPlayerStateEnum.values.first),
            'engageAccount': AnchorFieldPublicKey(value: Uint8List(0))});
  
    HoneypotPlayerAccount.withFields({
        required this.pubkeyField,
        required this.seedField,
        required this.gameIdField,
        required this.lamportsField,
        required this.bumpField,
        required this.lastSeenField,
        required this.stateField,
        required this.engageAccountField}) : super(
          name: 'Player',
          fields: {
            'pubkey': AnchorFieldPublicKey(value: pubkeyField.value),
            'seed': AnchorFieldArray<AnchorFieldU8>(value: seedField.value, size: 8),
            'gameId': AnchorFieldArray<AnchorFieldU8>(value: gameIdField.value, size: 32),
            'lamports': AnchorFieldU64(value: lamportsField.value),
            'bump': AnchorFieldU8(value: bumpField.value),
            'lastSeen': AnchorFieldI64(value: lastSeenField.value),
            'state': AnchorFieldEnum<HoneypotPlayerStateEnum>(value: stateField.value),
            'engageAccount': AnchorFieldPublicKey(value: engageAccountField.value)});
    
  
    @override
    HoneypotPlayerAccount deserialize(List<int> bytes) {
      consumeDiscriminator(bytes);
      
      var deserialized = Map.fromEntries(
          fields.entries.map((element) =>
              MapEntry(element.key, element.value.deserialize(bytes))));
      
      return HoneypotPlayerAccount.withFields(
          pubkeyField: deserialized['pubkey'] as AnchorFieldPublicKey,
          seedField: deserialized['seed'] as AnchorFieldArray<AnchorFieldU8>,
          gameIdField: deserialized['gameId'] as AnchorFieldArray<AnchorFieldU8>,
          lamportsField: deserialized['lamports'] as AnchorFieldU64,
          bumpField: deserialized['bump'] as AnchorFieldU8,
          lastSeenField: deserialized['lastSeen'] as AnchorFieldI64,
          stateField: deserialized['state'] as AnchorFieldEnum<HoneypotPlayerStateEnum>,
          engageAccountField: deserialized['engageAccount'] as AnchorFieldPublicKey
      );
    }
    
}

class HoneypotGameAccount extends AnchorAccount {
  final AnchorFieldArray<AnchorFieldU8> idField;
  final AnchorFieldPublicKey creatorField;
  final AnchorFieldEnum<HoneypotGameStateEnum> stateField;
  final AnchorFieldU64 playerCountField;
  final AnchorFieldU8 bumpField;
  
    HoneypotGameAccount()
      : idField = AnchorFieldArray<AnchorFieldU8>(value: [], size: 32),
        creatorField = AnchorFieldPublicKey(value: Uint8List(0)),
        stateField = AnchorFieldEnum<HoneypotGameStateEnum>(value: HoneypotGameStateEnum.values.first),
        playerCountField = AnchorFieldU64(value: 0),
        bumpField = AnchorFieldU8(value: 0),
      super(
          name: 'Game',
          fields: {
            'id': AnchorFieldArray<AnchorFieldU8>(value: [], size: 32),
            'creator': AnchorFieldPublicKey(value: Uint8List(0)),
            'state': AnchorFieldEnum<HoneypotGameStateEnum>(value: HoneypotGameStateEnum.values.first),
            'playerCount': AnchorFieldU64(value: 0),
            'bump': AnchorFieldU8(value: 0)});
  
    HoneypotGameAccount.withFields({
        required this.idField,
        required this.creatorField,
        required this.stateField,
        required this.playerCountField,
        required this.bumpField}) : super(
          name: 'Game',
          fields: {
            'id': AnchorFieldArray<AnchorFieldU8>(value: idField.value, size: 32),
            'creator': AnchorFieldPublicKey(value: creatorField.value),
            'state': AnchorFieldEnum<HoneypotGameStateEnum>(value: stateField.value),
            'playerCount': AnchorFieldU64(value: playerCountField.value),
            'bump': AnchorFieldU8(value: bumpField.value)});
    
  
    @override
    HoneypotGameAccount deserialize(List<int> bytes) {
      consumeDiscriminator(bytes);
      
      var deserialized = Map.fromEntries(
          fields.entries.map((element) =>
              MapEntry(element.key, element.value.deserialize(bytes))));
      
      return HoneypotGameAccount.withFields(
          idField: deserialized['id'] as AnchorFieldArray<AnchorFieldU8>,
          creatorField: deserialized['creator'] as AnchorFieldPublicKey,
          stateField: deserialized['state'] as AnchorFieldEnum<HoneypotGameStateEnum>,
          playerCountField: deserialized['playerCount'] as AnchorFieldU64,
          bumpField: deserialized['bump'] as AnchorFieldU8
      );
    }
    
}

class HoneypotEngageAccount extends AnchorAccount {
  final AnchorFieldPublicKey challengerField;
  final AnchorFieldPublicKey defenderField;
  final AnchorFieldI64 timestampField;
  final AnchorFieldStruct<HoneypotSealedMoveStruct> challengerSealedMoveField;
  final AnchorFieldStruct<HoneypotSealedMoveStruct> defenderSealedMoveField;
  final AnchorFieldEnum<HoneypotMoveTypeEnum> challengerMoveField;
  final AnchorFieldEnum<HoneypotMoveTypeEnum> defenderMoveField;
  final AnchorFieldEnum<HoneypotEngageResultEnum> resultField;
  final AnchorFieldU8 bumpField;
  
    HoneypotEngageAccount()
      : challengerField = AnchorFieldPublicKey(value: Uint8List(0)),
        defenderField = AnchorFieldPublicKey(value: Uint8List(0)),
        timestampField = AnchorFieldI64(value: 0),
        challengerSealedMoveField = AnchorFieldStruct<HoneypotSealedMoveStruct>(value: HoneypotSealedMoveStruct.factory()),
        defenderSealedMoveField = AnchorFieldStruct<HoneypotSealedMoveStruct>(value: HoneypotSealedMoveStruct.factory()),
        challengerMoveField = AnchorFieldEnum<HoneypotMoveTypeEnum>(value: HoneypotMoveTypeEnum.values.first),
        defenderMoveField = AnchorFieldEnum<HoneypotMoveTypeEnum>(value: HoneypotMoveTypeEnum.values.first),
        resultField = AnchorFieldEnum<HoneypotEngageResultEnum>(value: HoneypotEngageResultEnum.values.first),
        bumpField = AnchorFieldU8(value: 0),
      super(
          name: 'Engage',
          fields: {
            'challenger': AnchorFieldPublicKey(value: Uint8List(0)),
            'defender': AnchorFieldPublicKey(value: Uint8List(0)),
            'timestamp': AnchorFieldI64(value: 0),
            'challengerSealedMove': AnchorFieldStruct<HoneypotSealedMoveStruct>(value: HoneypotSealedMoveStruct.factory()),
            'defenderSealedMove': AnchorFieldStruct<HoneypotSealedMoveStruct>(value: HoneypotSealedMoveStruct.factory()),
            'challengerMove': AnchorFieldEnum<HoneypotMoveTypeEnum>(value: HoneypotMoveTypeEnum.values.first),
            'defenderMove': AnchorFieldEnum<HoneypotMoveTypeEnum>(value: HoneypotMoveTypeEnum.values.first),
            'result': AnchorFieldEnum<HoneypotEngageResultEnum>(value: HoneypotEngageResultEnum.values.first),
            'bump': AnchorFieldU8(value: 0)});
  
    HoneypotEngageAccount.withFields({
        required this.challengerField,
        required this.defenderField,
        required this.timestampField,
        required this.challengerSealedMoveField,
        required this.defenderSealedMoveField,
        required this.challengerMoveField,
        required this.defenderMoveField,
        required this.resultField,
        required this.bumpField}) : super(
          name: 'Engage',
          fields: {
            'challenger': AnchorFieldPublicKey(value: challengerField.value),
            'defender': AnchorFieldPublicKey(value: defenderField.value),
            'timestamp': AnchorFieldI64(value: timestampField.value),
            'challengerSealedMove': AnchorFieldStruct<HoneypotSealedMoveStruct>(value: challengerSealedMoveField.value),
            'defenderSealedMove': AnchorFieldStruct<HoneypotSealedMoveStruct>(value: defenderSealedMoveField.value),
            'challengerMove': AnchorFieldEnum<HoneypotMoveTypeEnum>(value: challengerMoveField.value),
            'defenderMove': AnchorFieldEnum<HoneypotMoveTypeEnum>(value: defenderMoveField.value),
            'result': AnchorFieldEnum<HoneypotEngageResultEnum>(value: resultField.value),
            'bump': AnchorFieldU8(value: bumpField.value)});
    
  
    @override
    HoneypotEngageAccount deserialize(List<int> bytes) {
      consumeDiscriminator(bytes);
      
      var deserialized = Map.fromEntries(
          fields.entries.map((element) =>
              MapEntry(element.key, element.value.deserialize(bytes))));
      
      return HoneypotEngageAccount.withFields(
          challengerField: deserialized['challenger'] as AnchorFieldPublicKey,
          defenderField: deserialized['defender'] as AnchorFieldPublicKey,
          timestampField: deserialized['timestamp'] as AnchorFieldI64,
          challengerSealedMoveField: deserialized['challengerSealedMove'] as AnchorFieldStruct<HoneypotSealedMoveStruct>,
          defenderSealedMoveField: deserialized['defenderSealedMove'] as AnchorFieldStruct<HoneypotSealedMoveStruct>,
          challengerMoveField: deserialized['challengerMove'] as AnchorFieldEnum<HoneypotMoveTypeEnum>,
          defenderMoveField: deserialized['defenderMove'] as AnchorFieldEnum<HoneypotMoveTypeEnum>,
          resultField: deserialized['result'] as AnchorFieldEnum<HoneypotEngageResultEnum>,
          bumpField: deserialized['bump'] as AnchorFieldU8
      );
    }
    
}

class HoneypotSealedMoveStruct extends AnchorStruct {
  final AnchorFieldArray<AnchorFieldU8> hashedMoveField;
  
  HoneypotSealedMoveStruct()
    : hashedMoveField = AnchorFieldArray<AnchorFieldU8>(value: [], size: 32),
      super(
          name: 'SealedMove',
          fields: {
            'hashedMove': AnchorFieldArray<AnchorFieldU8>(value: [], size: 32)});

  
    HoneypotSealedMoveStruct.withFields({
        required this.hashedMoveField}) : super(
          name: 'SealedMove',
          fields: {
            'hashedMove': AnchorFieldArray<AnchorFieldU8>(value: hashedMoveField.value, size: 32)});
    
  
  @override
  dartValue() => this;
  
  @override
  HoneypotSealedMoveStruct deserialize(List<int> bytes) {
    var deserialized = Map.fromEntries(
      fields.entries.map((element) => MapEntry(element.key, element.value.deserialize(bytes))));
    return HoneypotSealedMoveStruct.withFields(
        hashedMoveField: deserialized['hashedMove'] as AnchorFieldArray<AnchorFieldU8>);
  }
  
  @override
  Uint8List serialize() {
    return Uint8List.fromList(
        fields.values
          .map((element) => element.serialize())
          .reduce((value, element) => [...value, ...element])
    );
  }
  
  static HoneypotSealedMoveStruct factory() {
    return HoneypotSealedMoveStruct();
  }
}

class HoneypotRevealedMoveStruct extends AnchorStruct {
  final AnchorFieldEnum<HoneypotMoveTypeEnum> playField;
  final AnchorFieldString nonceField;
  
  HoneypotRevealedMoveStruct()
    : playField = AnchorFieldEnum<HoneypotMoveTypeEnum>(value: HoneypotMoveTypeEnum.values.first),
      nonceField = AnchorFieldString(value: ''),
      super(
          name: 'RevealedMove',
          fields: {
            'play': AnchorFieldEnum<HoneypotMoveTypeEnum>(value: HoneypotMoveTypeEnum.values.first),
            'nonce': AnchorFieldString(value: '')});

  
    HoneypotRevealedMoveStruct.withFields({
        required this.playField,
        required this.nonceField}) : super(
          name: 'RevealedMove',
          fields: {
            'play': AnchorFieldEnum<HoneypotMoveTypeEnum>(value: playField.value),
            'nonce': AnchorFieldString(value: nonceField.value)});
    
  
  @override
  dartValue() => this;
  
  @override
  HoneypotRevealedMoveStruct deserialize(List<int> bytes) {
    var deserialized = Map.fromEntries(
      fields.entries.map((element) => MapEntry(element.key, element.value.deserialize(bytes))));
    return HoneypotRevealedMoveStruct.withFields(
        playField: deserialized['play'] as AnchorFieldEnum<HoneypotMoveTypeEnum>,
        nonceField: deserialized['nonce'] as AnchorFieldString);
  }
  
  @override
  Uint8List serialize() {
    return Uint8List.fromList(
        fields.values
          .map((element) => element.serialize())
          .reduce((value, element) => [...value, ...element])
    );
  }
  
  static HoneypotRevealedMoveStruct factory() {
    return HoneypotRevealedMoveStruct();
  }
}

enum HoneypotEngageResultEnum implements AnchorEnum {
  NONE,
  DRAW,
  CHALLENGER,
  DEFENDER;
  
  @override
  int dartValue() => index;
  
  @override
  AnchorEnum deserialize(List<int> bytes) {
    var index = bytes[0];
    var values = HoneypotEngageResultEnum.values;

    bytes.removeRange(0, 1);

    if (index < 0 || index >= values.length) {
      throw Exception("Invalid enum index.");
    }
    
    return values[index];
  }

  @override
  List<int> serialize() {
    return Uint8List.fromList([index]);
  }
}  

enum HoneypotPlayerStateEnum implements AnchorEnum {
  IDLE,
  ENGAGED;
  
  @override
  int dartValue() => index;
  
  @override
  AnchorEnum deserialize(List<int> bytes) {
    var index = bytes[0];
    var values = HoneypotPlayerStateEnum.values;

    bytes.removeRange(0, 1);

    if (index < 0 || index >= values.length) {
      throw Exception("Invalid enum index.");
    }
    
    return values[index];
  }

  @override
  List<int> serialize() {
    return Uint8List.fromList([index]);
  }
}  

enum HoneypotMoveTypeEnum implements AnchorEnum {
  NONE,
  SMARTCONTRACT,
  TOKEN,
  HACK,
  ORACLE,
  AUDIT;
  
  @override
  int dartValue() => index;
  
  @override
  AnchorEnum deserialize(List<int> bytes) {
    var index = bytes[0];
    var values = HoneypotMoveTypeEnum.values;

    bytes.removeRange(0, 1);

    if (index < 0 || index >= values.length) {
      throw Exception("Invalid enum index.");
    }
    
    return values[index];
  }

  @override
  List<int> serialize() {
    return Uint8List.fromList([index]);
  }
}  

enum HoneypotGameStateEnum implements AnchorEnum {
  NEW,
  STARTED,
  ENDED;
  
  @override
  int dartValue() => index;
  
  @override
  AnchorEnum deserialize(List<int> bytes) {
    var index = bytes[0];
    var values = HoneypotGameStateEnum.values;

    bytes.removeRange(0, 1);

    if (index < 0 || index >= values.length) {
      throw Exception("Invalid enum index.");
    }
    
    return values[index];
  }

  @override
  List<int> serialize() {
    return Uint8List.fromList([index]);
  }
}  

class HoneypotMaxPlayersReachedError extends AnchorError {
  HoneypotMaxPlayersReachedError()
    : super(code: 6000, name: 'MaxPlayersReached', msg: 'Maximum number of Players Reached');

}

class HoneypotMaxLamportsReachedError extends AnchorError {
  HoneypotMaxLamportsReachedError()
    : super(code: 6001, name: 'MaxLamportsReached', msg: 'Maximum lamports Reached');

}

class HoneypotInvalidGameError extends AnchorError {
  HoneypotInvalidGameError()
    : super(code: 6002, name: 'InvalidGame', msg: 'Game ID is not valid');

}

class HoneypotPlayerOfflineError extends AnchorError {
  HoneypotPlayerOfflineError()
    : super(code: 6003, name: 'PlayerOffline', msg: 'Player is offline');

}

class HoneypotPlayerEngagedError extends AnchorError {
  HoneypotPlayerEngagedError()
    : super(code: 6004, name: 'PlayerEngaged', msg: 'Player is engaged');

}

class HoneypotInvalidPlayerStateError extends AnchorError {
  HoneypotInvalidPlayerStateError()
    : super(code: 6005, name: 'InvalidPlayerState', msg: 'Invalid Player state');

}

class HoneypotInvalidPlayerError extends AnchorError {
  HoneypotInvalidPlayerError()
    : super(code: 6006, name: 'InvalidPlayer', msg: 'Invalid Player');

}

class HoneypotMissingCommitmentError extends AnchorError {
  HoneypotMissingCommitmentError()
    : super(code: 6007, name: 'MissingCommitment', msg: 'One or more player moves have not been committed');

}

class HoneypotIllegalRevealError extends AnchorError {
  HoneypotIllegalRevealError()
    : super(code: 6008, name: 'IllegalReveal', msg: 'Reveal did not match the commitment');

}

class HoneypotInvalidCreatorError extends AnchorError {
  HoneypotInvalidCreatorError()
    : super(code: 6009, name: 'InvalidCreator', msg: 'Invalid Creator');

}

