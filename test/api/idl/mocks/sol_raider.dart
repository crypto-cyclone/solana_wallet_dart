// import 'dart:typed_data';
//
// import 'package:solana_wallet/api/idl/anchor_idl.dart';
// import 'package:solana_wallet/api/idl/anchor_idl_serialization_registry.dart';
//
// class SolRaiderAnchorIDL extends AnchorIDL {
//   final SolRaiderCreateMapInstruction createMapInstruction;
//   final SolRaiderUpdateMapInstruction updateMapInstruction;
//   final SolRaiderMapAccount mapAccount;
//   final SolRaiderMapRowAccount mapRowAccount;
//
//   SolRaiderAnchorIDL()
//     : createMapInstruction = SolRaiderCreateMapInstruction(),
//       updateMapInstruction = SolRaiderUpdateMapInstruction(),
//       mapAccount = SolRaiderMapAccount(),
//       mapRowAccount = SolRaiderMapRowAccount(),
//       super(
//           version: '0.1.0',
//           name: 'sol_raider',
//           metadata: AnchorMetadata(address: '8WdhLFkpr5sudFiCP1WknJvxVRagsUV6ohmKXuNBMZwG')) {
//         initialize();
//       }
//
//   void initialize() {
//       serializationRegistry.register<AnchorFieldString>(() => AnchorFieldString.factory());
//       serializationRegistry.register<AnchorFieldU32>(() => AnchorFieldU32.factory());
//       serializationRegistry.register<AnchorFieldNullableString>(() => AnchorFieldNullableString.factory());
//       serializationRegistry.register<AnchorFieldNullableVector<SolRaiderTileStruct>>(() => AnchorFieldNullableVector.factory<SolRaiderTileStruct>());
//       serializationRegistry.register<AnchorFieldPublicKey>(() => AnchorFieldPublicKey.factory());
//       serializationRegistry.register<AnchorFieldVector<SolRaiderTileStruct>>(() => AnchorFieldVector.factory<SolRaiderTileStruct>());
//       serializationRegistry.register<SolRaiderTileStruct>(() => SolRaiderTileStruct());
//       serializationRegistry.register<SolRaiderObjectStruct>(() => SolRaiderObjectStruct());
//       serializationRegistry.register<AnchorFieldU8>(() => AnchorFieldU8.factory());
//   }
//
// }
//
// class SolRaiderCreateMapInstruction extends AnchorInstruction {
//   final AnchorFieldString nameField;
//   final AnchorFieldU32 sizeField;
//   final AnchorInstructionAccount mapAccountAccount;
//   final AnchorInstructionAccount ownerAccount;
//   final AnchorInstructionAccount systemProgramAccount;
//
//     SolRaiderCreateMapInstruction()
//       : nameField = AnchorFieldString(name: 'name', value: '', index: 0),
//         sizeField = AnchorFieldU32(name: 'size', value: 0, index: 1),
//         mapAccountAccount = AnchorInstructionAccount(name: 'mapAccount', isMut: true, isSigner: false, address: '', index: 0),
//         ownerAccount = AnchorInstructionAccount(name: 'owner', isMut: true, isSigner: true, address: '', index: 1),
//         systemProgramAccount = AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: '', index: 2),
//       super(
//           name: 'createMap',
//           args: {
//             'name': AnchorFieldString(name: 'name', value: '', index: 0),
//             'size': AnchorFieldU32(name: 'size', value: 0, index: 1)},
//           accounts: {
//             'mapAccount': AnchorInstructionAccount(name: 'mapAccount', isMut: true, isSigner: false, address: '', index: 0),
//             'owner': AnchorInstructionAccount(name: 'owner', isMut: true, isSigner: true, address: '', index: 1),
//             'systemProgram': AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: '', index: 2)});
//
//     SolRaiderCreateMapInstruction withArgs(String name, int size) {
//       return SolRaiderCreateMapInstruction._withAll(
//         name, size,
//         mapAccountAccount.address, ownerAccount.address, systemProgramAccount.address,
//         true,
//         accountsSet
//       );
//     }
//
//     SolRaiderCreateMapInstruction withAccounts(String mapAccount, String owner, String systemProgram) {
//       return SolRaiderCreateMapInstruction._withAll(
//         nameField.value, sizeField.value,
//         mapAccount, owner, systemProgram,
//         argsSet,
//         true
//       );
//     }
//
//     SolRaiderCreateMapInstruction._withAll(String name, int size, String mapAccount, String owner, String systemProgram, bool argsSet, bool accountsSet)
//       : nameField = AnchorFieldString(name: 'name', value: name, index: 0),
//         sizeField = AnchorFieldU32(name: 'size', value: size, index: 1),
//         mapAccountAccount = AnchorInstructionAccount(name: 'mapAccount', isMut: true, isSigner: false, address: mapAccount, index: 0),
//         ownerAccount = AnchorInstructionAccount(name: 'owner', isMut: true, isSigner: true, address: owner, index: 1),
//         systemProgramAccount = AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: systemProgram, index: 2),
//         super(
//           name: 'createMap',
//           args: {
//             'name': AnchorFieldString(name: 'name', value: name, index: 0),
//             'size': AnchorFieldU32(name: 'size', value: size, index: 1)},
//           accounts: {
//             'mapAccount': AnchorInstructionAccount(name: 'mapAccount', isMut: true, isSigner: false, address: mapAccount, index: 0),
//             'owner': AnchorInstructionAccount(name: 'owner', isMut: true, isSigner: true, address: owner, index: 1),
//             'systemProgram': AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: systemProgram, index: 2)},
//           argsSet: argsSet,
//           accountsSet: accountsSet);
//
// }
//
// class SolRaiderUpdateMapInstruction extends AnchorInstruction {
//   final AnchorFieldNullableString nameField;
//   final AnchorFieldU32 rowIndexField;
//   final AnchorFieldNullableVector<SolRaiderTileStruct> tileUpdatesField;
//   final AnchorInstructionAccount mapAccountAccount;
//   final AnchorInstructionAccount rowAccountAccount;
//   final AnchorInstructionAccount ownerAccount;
//   final AnchorInstructionAccount systemProgramAccount;
//
//     SolRaiderUpdateMapInstruction()
//       : nameField = AnchorFieldNullableString(name: 'name', value: null, index: 0),
//         rowIndexField = AnchorFieldU32(name: 'rowIndex', value: 0, index: 1),
//         tileUpdatesField = AnchorFieldNullableVector<SolRaiderTileStruct>(name: 'tileUpdates', value: null, index: 2),
//         mapAccountAccount = AnchorInstructionAccount(name: 'mapAccount', isMut: true, isSigner: false, address: '', index: 0),
//         rowAccountAccount = AnchorInstructionAccount(name: 'rowAccount', isMut: true, isSigner: false, address: '', index: 1),
//         ownerAccount = AnchorInstructionAccount(name: 'owner', isMut: true, isSigner: true, address: '', index: 2),
//         systemProgramAccount = AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: '', index: 3),
//       super(
//           name: 'updateMap',
//           args: {
//             'name': AnchorFieldNullableString(name: 'name', value: null, index: 0),
//             'rowIndex': AnchorFieldU32(name: 'rowIndex', value: 0, index: 1),
//             'tileUpdates': AnchorFieldNullableVector<SolRaiderTileStruct>(name: 'tileUpdates', value: null, index: 2)},
//           accounts: {
//             'mapAccount': AnchorInstructionAccount(name: 'mapAccount', isMut: true, isSigner: false, address: '', index: 0),
//             'rowAccount': AnchorInstructionAccount(name: 'rowAccount', isMut: true, isSigner: false, address: '', index: 1),
//             'owner': AnchorInstructionAccount(name: 'owner', isMut: true, isSigner: true, address: '', index: 2),
//             'systemProgram': AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: '', index: 3)});
//
//     SolRaiderUpdateMapInstruction withArgs(String? name, int rowIndex, List<SolRaiderTileStruct>? tileUpdates) {
//       return SolRaiderUpdateMapInstruction._withAll(
//         name, rowIndex, tileUpdates,
//         mapAccountAccount.address, rowAccountAccount.address, ownerAccount.address, systemProgramAccount.address,
//         true,
//         accountsSet
//       );
//     }
//
//     SolRaiderUpdateMapInstruction withAccounts(String mapAccount, String rowAccount, String owner, String systemProgram) {
//       return SolRaiderUpdateMapInstruction._withAll(
//         nameField.value, rowIndexField.value, tileUpdatesField.value,
//         mapAccount, rowAccount, owner, systemProgram,
//         argsSet,
//         true
//       );
//     }
//
//     SolRaiderUpdateMapInstruction._withAll(String? name, int rowIndex, List<SolRaiderTileStruct>? tileUpdates, String mapAccount, String rowAccount, String owner, String systemProgram, bool argsSet, bool accountsSet)
//       : nameField = AnchorFieldNullableString(name: 'name', value: name, index: 0),
//         rowIndexField = AnchorFieldU32(name: 'rowIndex', value: rowIndex, index: 1),
//         tileUpdatesField = AnchorFieldNullableVector<SolRaiderTileStruct>(name: 'tileUpdates', value: tileUpdates, index: 2),
//         mapAccountAccount = AnchorInstructionAccount(name: 'mapAccount', isMut: true, isSigner: false, address: mapAccount, index: 0),
//         rowAccountAccount = AnchorInstructionAccount(name: 'rowAccount', isMut: true, isSigner: false, address: rowAccount, index: 1),
//         ownerAccount = AnchorInstructionAccount(name: 'owner', isMut: true, isSigner: true, address: owner, index: 2),
//         systemProgramAccount = AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: systemProgram, index: 3),
//         super(
//           name: 'updateMap',
//           args: {
//             'name': AnchorFieldNullableString(name: 'name', value: name, index: 0),
//             'rowIndex': AnchorFieldU32(name: 'rowIndex', value: rowIndex, index: 1),
//             'tileUpdates': AnchorFieldNullableVector<SolRaiderTileStruct>(name: 'tileUpdates', value: tileUpdates, index: 2)},
//           accounts: {
//             'mapAccount': AnchorInstructionAccount(name: 'mapAccount', isMut: true, isSigner: false, address: mapAccount, index: 0),
//             'rowAccount': AnchorInstructionAccount(name: 'rowAccount', isMut: true, isSigner: false, address: rowAccount, index: 1),
//             'owner': AnchorInstructionAccount(name: 'owner', isMut: true, isSigner: true, address: owner, index: 2),
//             'systemProgram': AnchorInstructionAccount(name: 'systemProgram', isMut: false, isSigner: false, address: systemProgram, index: 3)},
//           argsSet: argsSet,
//           accountsSet: accountsSet);
//
// }
//
// class SolRaiderMapAccount extends AnchorAccount {
//   final AnchorFieldString nameField;
//   final AnchorFieldPublicKey ownerField;
//   final AnchorFieldU32 sizeField;
//
//     SolRaiderMapAccount()
//       : nameField = AnchorFieldString(name: 'name', value: '', index: 0),
//         ownerField = AnchorFieldPublicKey(name: 'owner', value: Uint8List(0), index: 1),
//         sizeField = AnchorFieldU32(name: 'size', value: 0, index: 2),
//       super(
//           name: 'Map',
//           fields: {
//             'name': AnchorFieldString(name: 'name', value: '', index: 0),
//             'owner': AnchorFieldPublicKey(name: 'owner', value: Uint8List(0), index: 1),
//             'size': AnchorFieldU32(name: 'size', value: 0, index: 2)});
//
//     SolRaiderMapAccount.withFields({
//         required this.nameField,
//         required this.ownerField,
//         required this.sizeField}) : super(
//           name: 'Map',
//           fields: {
//             'name': AnchorFieldString(name: 'name', value: '', index: 0),
//             'owner': AnchorFieldPublicKey(name: 'owner', value: Uint8List(0), index: 1),
//             'size': AnchorFieldU32(name: 'size', value: 0, index: 2)});
//
//
//     @override
//     SolRaiderMapAccount deserialize(List<int> bytes) {
//       consumeDiscriminator(bytes);
//
//       var deserialized = Map.fromEntries(
//           fields.entries.map((element) =>
//               MapEntry(element.key, element.value.deserialize(bytes))));
//
//       return SolRaiderMapAccount.withFields(
//           nameField: deserialized['name'] as AnchorFieldString,
//           ownerField: deserialized['owner'] as AnchorFieldPublicKey,
//           sizeField: deserialized['size'] as AnchorFieldU32
//       );
//     }
//
// }
//
// class SolRaiderMapRowAccount extends AnchorAccount {
//   final AnchorFieldU32 rowField;
//   final AnchorFieldVector<SolRaiderTileStruct> stateField;
//
//     SolRaiderMapRowAccount()
//       : rowField = AnchorFieldU32(name: 'row', value: 0, index: 0),
//         stateField = AnchorFieldVector<SolRaiderTileStruct>(name: 'state', value: [], index: 1),
//       super(
//           name: 'MapRow',
//           fields: {
//             'row': AnchorFieldU32(name: 'row', value: 0, index: 0),
//             'state': AnchorFieldVector<SolRaiderTileStruct>(name: 'state', value: [], index: 1)});
//
//     SolRaiderMapRowAccount.withFields({
//         required this.rowField,
//         required this.stateField}) : super(
//           name: 'MapRow',
//           fields: {
//             'row': AnchorFieldU32(name: 'row', value: 0, index: 0),
//             'state': AnchorFieldVector<SolRaiderTileStruct>(name: 'state', value: [], index: 1)});
//
//
//     @override
//     SolRaiderMapRowAccount deserialize(List<int> bytes) {
//       consumeDiscriminator(bytes);
//
//       var deserialized = Map.fromEntries(
//           fields.entries.map((element) =>
//               MapEntry(element.key, element.value.deserialize(bytes))));
//
//       return SolRaiderMapRowAccount.withFields(
//           rowField: deserialized['row'] as AnchorFieldU32,
//           stateField: deserialized['state'] as AnchorFieldVector<SolRaiderTileStruct>
//       );
//     }
//
// }
//
// class SolRaiderTileStruct extends AnchorStruct {
//   final AnchorFieldU32 rowField;
//   final AnchorFieldU32 colField;
//   final AnchorFieldU8 classField;
//
//   SolRaiderTileStruct()
//     : rowField = AnchorFieldU32(name: 'row', value: 0, index: 0),
//       colField = AnchorFieldU32(name: 'col', value: 0, index: 1),
//       classField = AnchorFieldU8(name: 'class', value: 0, index: 2),
//       super(
//           name: 'Tile',
//           fields: {
//             'row': AnchorFieldU32(name: 'row', value: 0, index: 0),
//             'col': AnchorFieldU32(name: 'col', value: 0, index: 1),
//             'class': AnchorFieldU8(name: 'class', value: 0, index: 2)});
//
//
//     SolRaiderTileStruct.withFields({
//         required this.rowField,
//         required this.colField,
//         required this.classField}) : super(
//           name: 'Tile',
//           fields: {
//             'row': AnchorFieldU32(name: 'row', value: 0, index: 0),
//             'col': AnchorFieldU32(name: 'col', value: 0, index: 1),
//             'class': AnchorFieldU8(name: 'class', value: 0, index: 2)});
//
//
//   @override
//   SolRaiderTileStruct deserialize(List<int> bytes) {
//     var deserialized = Map.fromEntries(
//       fields.entries.map((element) => MapEntry(element.key, element.value.deserialize(bytes))));
//     return SolRaiderTileStruct.withFields(
//         rowField: deserialized['row'] as AnchorFieldU32,
//         colField: deserialized['col'] as AnchorFieldU32,
//         classField: deserialized['class'] as AnchorFieldU8);
//   }
// }
//
// class SolRaiderObjectStruct extends AnchorStruct {
//   final AnchorFieldU32 classField;
//   final AnchorFieldString nameField;
//
//   SolRaiderObjectStruct()
//     : classField = AnchorFieldU32(name: 'class', value: 0, index: 0),
//       nameField = AnchorFieldString(name: 'name', value: '', index: 1),
//       super(
//           name: 'Object',
//           fields: {
//             'class': AnchorFieldU32(name: 'class', value: 0, index: 0),
//             'name': AnchorFieldString(name: 'name', value: '', index: 1)});
//
//
//     SolRaiderObjectStruct.withFields({
//         required this.classField,
//         required this.nameField}) : super(
//           name: 'Object',
//           fields: {
//             'class': AnchorFieldU32(name: 'class', value: 0, index: 0),
//             'name': AnchorFieldString(name: 'name', value: '', index: 1)});
//
//
//   @override
//   SolRaiderObjectStruct deserialize(List<int> bytes) {
//     var deserialized = Map.fromEntries(
//       fields.entries.map((element) => MapEntry(element.key, element.value.deserialize(bytes))));
//     return SolRaiderObjectStruct.withFields(
//         classField: deserialized['class'] as AnchorFieldU32,
//         nameField: deserialized['name'] as AnchorFieldString);
//   }
// }
//
// enum SolRaiderTileClassEnum {
//   NONE,
//   TUNDRA,
//   RAINFOREST,
//   DESERT,
//   TAIGA,
//   GRASSLAND,
//   MOUNTAIN,
//   WETLAND,
//   SAVANNAH,
//   CHAPARRAL,
//   CORALREEF
// }
//
// enum SolRaiderObjectClassEnum {
//   INFANTRY,
//   STRUCTURE,
//   TRAP
// }
//
// class SolRaiderStateMismatchError extends AnchorError {
//   SolRaiderStateMismatchError()
//     : super(code: 6000, name: 'StateMismatch', msg: 'Current state does not match on-chain state');
//
// }
//
