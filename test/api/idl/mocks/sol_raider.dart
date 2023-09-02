import 'dart:typed_data';
 
import 'package:solana_wallet/api/idl/anchor_idl.dart';
import 'package:solana_wallet/api/idl/anchor_idl_serialization_registry.dart';

class SolRaiderAnchorIDL extends AnchorIDL {
  final SolRaiderCreateMapInstruction createMapInstruction;
  final SolRaiderUpdateMapInstruction updateMapInstruction;
  final SolRaiderMapAccount mapAccount;
  
  SolRaiderAnchorIDL()
    : createMapInstruction = SolRaiderCreateMapInstruction(),
      updateMapInstruction = SolRaiderUpdateMapInstruction(),
      mapAccount = SolRaiderMapAccount(),
      super(
          version: '0.1.0',
          name: 'sol_raider',
          metadata: AnchorMetadata(address: '8WdhLFkpr5sudFiCP1WknJvxVRagsUV6ohmKXuNBMZwG')) {
        initialize();
      }

  void initialize() {
      serializationRegistry.register<AnchorFieldString>(() => AnchorFieldString.factory());
      serializationRegistry.register<AnchorFieldU64>(() => AnchorFieldU64.factory());
      serializationRegistry.register<AnchorFieldBytes>(() => AnchorFieldBytes.factory());
      serializationRegistry.register<AnchorFieldNullableBytes>(() => AnchorFieldNullableBytes.factory());
      serializationRegistry.register<AnchorFieldNullableString>(() => AnchorFieldNullableString.factory());
      serializationRegistry.register<AnchorFieldNullableU64>(() => AnchorFieldNullableU64.factory());
      serializationRegistry.register<AnchorFieldPublicKey>(() => AnchorFieldPublicKey.factory());
      serializationRegistry.register<AnchorFieldVector<SolRaiderTileStruct>>(() => AnchorFieldVector.factory<SolRaiderTileStruct>());
      serializationRegistry.register<SolRaiderTileStruct>(() => SolRaiderTileStruct());
      serializationRegistry.register<SolRaiderObjectStruct>(() => SolRaiderObjectStruct());
      serializationRegistry.register<AnchorFieldU32>(() => AnchorFieldU32.factory());
      serializationRegistry.register<AnchorFieldVector<SolRaiderObjectStruct>>(() => AnchorFieldVector.factory<SolRaiderObjectStruct>());
  }

}

class SolRaiderCreateMapInstruction extends AnchorInstruction {
  final AnchorFieldString nameField;
  final AnchorFieldU64 sizeField;
  final AnchorFieldU64 rewardField;
  final AnchorInstructionAccount mapAccountAccount;
  final AnchorInstructionAccount ownerAccount;
  final AnchorInstructionAccount systemProgramAccount;

    SolRaiderCreateMapInstruction()
      : nameField = AnchorFieldString(name: 'name', value: '', index: 0),
        sizeField = AnchorFieldU64(name: 'size', value: 0, index: 1),
        rewardField = AnchorFieldU64(name: 'reward', value: 0, index: 2),
        mapAccountAccount = AnchorInstructionAccount(name: 'mapAccount', isMut: true, isSigner: false, address: '', index: 0),
        ownerAccount = AnchorInstructionAccount(name: 'owner', isMut: true, isSigner: true, address: '', index: 1),
        systemProgramAccount = AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: '', index: 2),
      super(
          name: 'createMap',
          args: {
            'name': AnchorFieldString(name: 'name', value: '', index: 0),
            'size': AnchorFieldU64(name: 'size', value: 0, index: 1),
            'reward': AnchorFieldU64(name: 'reward', value: 0, index: 2)},
          accounts: {
            'mapAccount': AnchorInstructionAccount(name: 'mapAccount', isMut: true, isSigner: false, address: '', index: 0),
            'owner': AnchorInstructionAccount(name: 'owner', isMut: true, isSigner: true, address: '', index: 1),
            'systemProgram': AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: '', index: 2)});
  
    SolRaiderCreateMapInstruction withArgs(String name, int size, int reward) {
      return SolRaiderCreateMapInstruction._withAll(
        name, size, reward,
        mapAccountAccount.address, ownerAccount.address, systemProgramAccount.address,
        true,
        accountsSet
      );
    }
  
    SolRaiderCreateMapInstruction withAccounts(String mapAccount, String owner, String systemProgram) {
      return SolRaiderCreateMapInstruction._withAll(
        nameField.value, sizeField.value, rewardField.value,
        mapAccount, owner, systemProgram,
        argsSet,
        true
      );
    }
  
    SolRaiderCreateMapInstruction._withAll(String name, int size, int reward, String mapAccount, String owner, String systemProgram, bool argsSet, bool accountsSet)
      : nameField = AnchorFieldString(name: 'name', value: name, index: 0),
        sizeField = AnchorFieldU64(name: 'size', value: size, index: 1),
        rewardField = AnchorFieldU64(name: 'reward', value: reward, index: 2),
        mapAccountAccount = AnchorInstructionAccount(name: 'mapAccount', isMut: true, isSigner: false, address: mapAccount, index: 0),
        ownerAccount = AnchorInstructionAccount(name: 'owner', isMut: true, isSigner: true, address: owner, index: 1),
        systemProgramAccount = AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: systemProgram, index: 2),
        super(
          name: 'createMap',
          args: {
            'name': AnchorFieldString(name: 'name', value: name, index: 0),
            'size': AnchorFieldU64(name: 'size', value: size, index: 1),
            'reward': AnchorFieldU64(name: 'reward', value: reward, index: 2)},
          accounts: {
            'mapAccount': AnchorInstructionAccount(name: 'mapAccount', isMut: true, isSigner: false, address: mapAccount, index: 0),
            'owner': AnchorInstructionAccount(name: 'owner', isMut: true, isSigner: true, address: owner, index: 1),
            'systemProgram': AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: systemProgram, index: 2)},
          argsSet: argsSet,
          accountsSet: accountsSet);
  
}

class SolRaiderUpdateMapInstruction extends AnchorInstruction {
  final AnchorFieldBytes mapChecksumField;
  final AnchorFieldNullableBytes tileUpdatesField;
  final AnchorFieldNullableString nameField;
  final AnchorFieldNullableU64 rewardField;
  final AnchorInstructionAccount mapAccountAccount;
  final AnchorInstructionAccount ownerAccount;
  final AnchorInstructionAccount systemProgramAccount;

    SolRaiderUpdateMapInstruction()
      : mapChecksumField = AnchorFieldBytes(name: 'mapChecksum', value: Uint8List(0), index: 0),
        tileUpdatesField = AnchorFieldNullableBytes(name: 'tileUpdates', value: null, index: 1),
        nameField = AnchorFieldNullableString(name: 'name', value: null, index: 2),
        rewardField = AnchorFieldNullableU64(name: 'reward', value: null, index: 3),
        mapAccountAccount = AnchorInstructionAccount(name: 'mapAccount', isMut: true, isSigner: false, address: '', index: 0),
        ownerAccount = AnchorInstructionAccount(name: 'owner', isMut: true, isSigner: true, address: '', index: 1),
        systemProgramAccount = AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: '', index: 2),
      super(
          name: 'updateMap',
          args: {
            'mapChecksum': AnchorFieldBytes(name: 'mapChecksum', value: Uint8List(0), index: 0),
            'tileUpdates': AnchorFieldNullableBytes(name: 'tileUpdates', value: null, index: 1),
            'name': AnchorFieldNullableString(name: 'name', value: null, index: 2),
            'reward': AnchorFieldNullableU64(name: 'reward', value: null, index: 3)},
          accounts: {
            'mapAccount': AnchorInstructionAccount(name: 'mapAccount', isMut: true, isSigner: false, address: '', index: 0),
            'owner': AnchorInstructionAccount(name: 'owner', isMut: true, isSigner: true, address: '', index: 1),
            'systemProgram': AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: '', index: 2)});
  
    SolRaiderUpdateMapInstruction withArgs(Uint8List mapChecksum, Uint8List? tileUpdates, String? name, int? reward) {
      return SolRaiderUpdateMapInstruction._withAll(
        mapChecksum, tileUpdates, name, reward,
        mapAccountAccount.address, ownerAccount.address, systemProgramAccount.address,
        true,
        accountsSet
      );
    }
  
    SolRaiderUpdateMapInstruction withAccounts(String mapAccount, String owner, String systemProgram) {
      return SolRaiderUpdateMapInstruction._withAll(
        mapChecksumField.value, tileUpdatesField.value, nameField.value, rewardField.value,
        mapAccount, owner, systemProgram,
        argsSet,
        true
      );
    }
  
    SolRaiderUpdateMapInstruction._withAll(Uint8List mapChecksum, Uint8List? tileUpdates, String? name, int? reward, String mapAccount, String owner, String systemProgram, bool argsSet, bool accountsSet)
      : mapChecksumField = AnchorFieldBytes(name: 'mapChecksum', value: mapChecksum, index: 0),
        tileUpdatesField = AnchorFieldNullableBytes(name: 'tileUpdates', value: tileUpdates, index: 1),
        nameField = AnchorFieldNullableString(name: 'name', value: name, index: 2),
        rewardField = AnchorFieldNullableU64(name: 'reward', value: reward, index: 3),
        mapAccountAccount = AnchorInstructionAccount(name: 'mapAccount', isMut: true, isSigner: false, address: mapAccount, index: 0),
        ownerAccount = AnchorInstructionAccount(name: 'owner', isMut: true, isSigner: true, address: owner, index: 1),
        systemProgramAccount = AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: systemProgram, index: 2),
        super(
          name: 'updateMap',
          args: {
            'mapChecksum': AnchorFieldBytes(name: 'mapChecksum', value: mapChecksum, index: 0),
            'tileUpdates': AnchorFieldNullableBytes(name: 'tileUpdates', value: tileUpdates, index: 1),
            'name': AnchorFieldNullableString(name: 'name', value: name, index: 2),
            'reward': AnchorFieldNullableU64(name: 'reward', value: reward, index: 3)},
          accounts: {
            'mapAccount': AnchorInstructionAccount(name: 'mapAccount', isMut: true, isSigner: false, address: mapAccount, index: 0),
            'owner': AnchorInstructionAccount(name: 'owner', isMut: true, isSigner: true, address: owner, index: 1),
            'systemProgram': AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: systemProgram, index: 2)},
          argsSet: argsSet,
          accountsSet: accountsSet);
  
}

class SolRaiderMapAccount extends AnchorAccount {
  final AnchorFieldString nameField;
  final AnchorFieldPublicKey ownerField;
  final AnchorFieldVector<AnchorFieldVector<SolRaiderTileStruct>> stateField;
  final AnchorFieldU64 rewardField;
  
    SolRaiderMapAccount()
      : nameField = AnchorFieldString(name: 'name', value: '', index: 0),
        ownerField = AnchorFieldPublicKey(name: 'owner', value: Uint8List(0), index: 1),
        stateField = AnchorFieldVector<AnchorFieldVector<SolRaiderTileStruct>>(name: 'state', value: [], index: 2),
        rewardField = AnchorFieldU64(name: 'reward', value: 0, index: 3),
      super(
          name: 'Map',
          fields: {
            'name': AnchorFieldString(name: 'name', value: '', index: 0),
            'owner': AnchorFieldPublicKey(name: 'owner', value: Uint8List(0), index: 1),
            'state': AnchorFieldVector<AnchorFieldVector<SolRaiderTileStruct>>(name: 'state', value: [], index: 2),
            'reward': AnchorFieldU64(name: 'reward', value: 0, index: 3)});
  
    SolRaiderMapAccount.withFields({
        required this.nameField,
        required this.ownerField,
        required this.stateField,
        required this.rewardField}) : super(
          name: 'Map',
          fields: {
            'name': AnchorFieldString(name: 'name', value: '', index: 0),
            'owner': AnchorFieldPublicKey(name: 'owner', value: Uint8List(0), index: 1),
            'state': AnchorFieldVector<AnchorFieldVector<SolRaiderTileStruct>>(name: 'state', value: [], index: 2),
            'reward': AnchorFieldU64(name: 'reward', value: 0, index: 3)});
    
  
    @override
    SolRaiderMapAccount deserialize(List<int> bytes) {
      consumeDiscriminator(bytes);
      
      var deserialized = Map.fromEntries(
          fields.entries.map((element) =>
              MapEntry(element.key, element.value.deserialize(bytes))));
      
      return SolRaiderMapAccount.withFields(
          nameField: deserialized['name'] as AnchorFieldString,
          ownerField: deserialized['owner'] as AnchorFieldPublicKey,
          stateField: deserialized['state'] as AnchorFieldVector<AnchorFieldVector<SolRaiderTileStruct>>,
          rewardField: deserialized['reward'] as AnchorFieldU64
      );
    }
    
}

class SolRaiderTileStruct extends AnchorStruct {
  final AnchorFieldU32 classField;
  final AnchorFieldVector<SolRaiderObjectStruct> objectsField;
  
  SolRaiderTileStruct()
    : classField = AnchorFieldU32(name: 'class', value: 0, index: 0),
      objectsField = AnchorFieldVector<SolRaiderObjectStruct>(name: 'objects', value: [], index: 1),
      super(
          name: 'Tile',
          fields: {
            'class': AnchorFieldU32(name: 'class', value: 0, index: 0),
            'objects': AnchorFieldVector<SolRaiderObjectStruct>(name: 'objects', value: [], index: 1)});

  
    SolRaiderTileStruct.withFields({
        required this.classField,
        required this.objectsField}) : super(
          name: 'Tile',
          fields: {
            'class': AnchorFieldU32(name: 'class', value: 0, index: 0),
            'objects': AnchorFieldVector<SolRaiderObjectStruct>(name: 'objects', value: [], index: 1)});
    
  
  @override
  SolRaiderTileStruct deserialize(List<int> bytes) {
    var deserialized = Map.fromEntries(
      fields.entries.map((element) => MapEntry(element.key, element.value.deserialize(bytes))));
    return SolRaiderTileStruct.withFields(
        classField: deserialized['class'] as AnchorFieldU32,
        objectsField: deserialized['objects'] as AnchorFieldVector<SolRaiderObjectStruct>);
  }
}

class SolRaiderObjectStruct extends AnchorStruct {
  final AnchorFieldU32 classField;
  final AnchorFieldString nameField;
  
  SolRaiderObjectStruct()
    : classField = AnchorFieldU32(name: 'class', value: 0, index: 0),
      nameField = AnchorFieldString(name: 'name', value: '', index: 1),
      super(
          name: 'Object',
          fields: {
            'class': AnchorFieldU32(name: 'class', value: 0, index: 0),
            'name': AnchorFieldString(name: 'name', value: '', index: 1)});

  
    SolRaiderObjectStruct.withFields({
        required this.classField,
        required this.nameField}) : super(
          name: 'Object',
          fields: {
            'class': AnchorFieldU32(name: 'class', value: 0, index: 0),
            'name': AnchorFieldString(name: 'name', value: '', index: 1)});
    
  
  @override
  SolRaiderObjectStruct deserialize(List<int> bytes) {
    var deserialized = Map.fromEntries(
      fields.entries.map((element) => MapEntry(element.key, element.value.deserialize(bytes))));
    return SolRaiderObjectStruct.withFields(
        classField: deserialized['class'] as AnchorFieldU32,
        nameField: deserialized['name'] as AnchorFieldString);
  }
}

enum SolRaiderTileClassEnum {
  PAVED,
  FORTIFIED,
  WILD
}  

enum SolRaiderObjectClassEnum {
  INFANTRY,
  STRUCTURE,
  TRAP
}  

class SolRaiderStateMismatchError extends AnchorError {
  SolRaiderStateMismatchError()
    : super(code: 6000, name: 'StateMismatch', msg: 'Current state does not match on-chain state');

}

