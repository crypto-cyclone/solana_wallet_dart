import 'dart:convert';
import 'dart:typed_data';

import 'package:solana_wallet/domain/model/transaction/anchor/anchor_instruction_data.dart';
import 'package:solana_wallet/domain/model/transaction/solana/header.dart';
import 'package:solana_wallet/domain/model/transaction/solana/instruction.dart';
import 'package:solana_wallet/domain/model/transaction/solana/message.dart';
import 'package:solana_wallet/domain/model/transaction/solana/transaction.dart';
import 'package:solana_wallet/encoder/anchor/anchor_encoder.dart';
import 'package:solana_wallet/util/anchor.dart';
import 'package:solana_wallet/util/byte_conversion.dart';
import 'package:solana_wallet/util/string.dart';

import 'package:collection/collection.dart';

import 'anchor_idl_serialization_registry.dart';

class AnchorIDL {
  final String version;
  final String name;
  final AnchorMetadata metadata;

  AnchorIDL({
    required this.version,
    required this.name,
    required this.metadata
  });
}

class AnchorMetadata {
  final String address;

  AnchorMetadata({
    required this.address
  });
}

class AnchorInstruction {
  final _anchorEncoder = AnchorEncoder();

  final String name;
  final Map<String, AnchorField> args;
  final Map<String, AnchorInstructionAccount> accounts;
  final bool argsSet;
  final bool accountsSet;

  AnchorInstruction({
    required this.name,
    required this.args,
    required this.accounts,
    this.argsSet = false,
    this.accountsSet = false,
  });

  Transaction toTransaction(String programId, String blockhash) {
    if (!argsSet) {
      throw Exception('Args not set');
    }

    if (!accountsSet) {
      throw Exception('Accounts not set');
    }

    return _toTransactionUnsafe(programId, blockhash);
  }

  Transaction _toTransactionUnsafe(String programId, String blockhash) {
    var accountList = accounts.values.toList();
    accountList.sort(compareAccounts);

    Transaction transaction = Transaction(
        message: Message(
            header: Header(
                noSigs: accountList.where((element) => element.isSigner).length,
                noSignedReadOnlyAccounts: accountList.where((element) => element.isSigner && !element.isMut).length,
                noUnsignedReadOnlyAccounts: accountList.where((element) => !element.isSigner && !element.isMut).length + 1
            ),
            accountAddresses: [
              ...accountList.map((e) => e.address).toList(),
              programId
            ],
            blockhash: blockhash,
            instructions: [
              Instruction(
                  programIdIndex: accountList.length,
                  accountIndices: Uint8List.fromList(accountList.map((e) => e.index).toList()),
                  data: AnchorInstructionData(
                      discriminator: _anchorEncoder.encodeDiscriminator("global", toSnakeCase(name)),
                      args: args.values.toList()
                  )
              )
            ]
        )
    );

    return transaction;
  }
}

class AnchorInstructionAccount {
  final int index;
  final String name;
  final bool isMut;
  final bool isSigner;
  final String address;

  AnchorInstructionAccount({
    required this.index,
    required this.name,
    required this.isMut,
    required this.isSigner,
    required this.address
  });
}

class AnchorAccount extends AnchorSerializable {
  final _anchorEncoder = AnchorEncoder();

  final String name;
  final Map<String, AnchorField> fields;

  AnchorAccount({
    required this.name,
    required this.fields
  });

  consumeDiscriminator(List<int> bytes) {
    var discriminator = _anchorEncoder.encodeDiscriminator(
        "", toPascalCase(name)
    );

    if (!ListEquality().equals(discriminator, bytes.sublist(0, 8))) {
      throw Exception('Discriminator mismatch');
    }

    bytes.removeRange(0, 8);
  }

  @override
  AnchorSerializable deserialize(List<int> bytes) {
    throw UnimplementedError();
  }

  @override
  List<int> serialize() {
    throw UnimplementedError();
  }
}

class AnchorStruct extends AnchorSerializable {
  final String name;
  final Map<String, AnchorSerializable> fields;

  AnchorStruct({
    required this.name,
    required this.fields
  });

  AnchorStruct deserialize(List<int> bytes) {
    throw UnimplementedError();
  }

  @override
  List<int> serialize() {
    throw UnimplementedError();
  }
}

class AnchorEnum<T extends Enum> extends AnchorSerializable {
  final T value;

  AnchorEnum({
    required this.value
  });

  AnchorEnum deserialize(List<int> bytes) {
    throw UnimplementedError();
  }

  @override
  List<int> serialize() {
    throw UnimplementedError();
  }
}

class AnchorError {
  final int code;
  final String name;
  final String msg;

  AnchorError({
    required this.code,
    required this.name,
    required this.msg
  });
}

class AnchorField<T> extends AnchorSerializable {
  final int index;
  final String name;

  AnchorField({
    required this.index,
    required this.name,
  });

  Uint8List serialize() {
    return Uint8List(0);
  }

  AnchorField deserialize(List<int> bytes) {
    throw Exception('Not implemented');
  }
}

class AnchorFieldString extends AnchorField<String> {
  final String value;

  AnchorFieldString({
    required int index,
    required String name,
    required this.value
  }) : super(index: index, name: name);

  @override
  Uint8List serialize() {
    Uint8List bytes = Uint8List.fromList(utf8.encode(value));
    Uint8List resultLengthBytes = toLEByteArray(value.length, 4);
    return Uint8List.fromList([
      ...resultLengthBytes,
      ...bytes
    ]);
  }

  @override
  AnchorFieldString deserialize(List<int> bytes) {
    int resultLength = fromLEByteArray(Uint8List.fromList(bytes.sublist(0, 4)));
    String result = utf8.decode(bytes.sublist(4, 4 + resultLength));
    bytes.removeRange(0, 4 + resultLength);
    return AnchorFieldString(index: index, name: name, value: result);
  }

  static AnchorFieldString factory() {
    return AnchorFieldString(index: 0, name: '', value: '');
  }
}

class AnchorFieldNullableString extends AnchorField<String?> {
  final String? value;

  AnchorFieldNullableString({
    required int index,
    required String name,
    required this.value
  }) : super(index: index, name: name);

  @override
  Uint8List serialize() {
    if (value == null) {
      return Uint8List(0);
    }

    Uint8List bytes = Uint8List.fromList(utf8.encode(value!));
    Uint8List nameLengthBytes = toLEByteArray(value!.length, 4);
    return Uint8List.fromList([
      1,
      ...nameLengthBytes,
      ...bytes
    ]);
  }

  @override
  AnchorFieldNullableString deserialize(List<int> bytes) {
    if (bytes.isEmpty) {
      throw Exception('Empty byte array provided');
    }

    if (bytes.first == 0) {
      return AnchorFieldNullableString(index: index, name: name, value: null);
    }

    if (bytes.first != 1) {
      throw Exception('Invalid bytes');
    }

    if (bytes.length < 5) {
      throw Exception('Insufficient bytes for length field');
    }

    int resultLength = fromLEByteArray(Uint8List.fromList(bytes.sublist(1, 5)));
    String result = utf8.decode(bytes.sublist(5, 5 + resultLength));
    bytes.removeRange(0, 5 + resultLength);
    return AnchorFieldNullableString(index: index, name: name, value: result);
  }

  static AnchorFieldNullableString factory() {
    return AnchorFieldNullableString(index: 0, name: '', value: null);
  }
}

class AnchorFieldU64 extends AnchorField<int> {
  final int value;

  AnchorFieldU64({
    required int index,
    required String name,
    required this.value
  }) : super(index: index, name: name);

  @override
  Uint8List serialize() {
    return toLEByteArray(value, 8);
  }

  @override
  AnchorFieldU64 deserialize(List<int> bytes) {
    int result = fromLEByteArray(Uint8List.fromList(bytes.sublist(0, 8)));
    bytes.removeRange(0, 8);
    return AnchorFieldU64(index: index, name: name, value: result);
  }

  static AnchorFieldU64 factory() {
    return AnchorFieldU64(index: 0, name: '', value: 0);
  }
}

class AnchorFieldNullableU64 extends AnchorField<int?> {
  final int? value;

  AnchorFieldNullableU64({
    required int index,
    required String name,
    required this.value
  }) : super(index: index, name: name);

  @override
  Uint8List serialize() {
    if (value == null) {
      return Uint8List(0);
    }

    return toLEByteArray(value!, 8);
  }

  @override
  AnchorFieldNullableU64 deserialize(List<int> bytes) {
    if (bytes.isEmpty) {
      throw Exception('Empty byte array provided');
    }

    if (bytes.first == 0) {
      return AnchorFieldNullableU64(index: index, name: name, value: null);
    }

    if (bytes.first != 1) {
      throw Exception('Invalid bytes');
    }

    if (bytes.length < 9) {
      throw Exception('Insufficient bytes for length field');
    }

    int result = fromLEByteArray(Uint8List.fromList(bytes.sublist(1, 9)));
    bytes.removeRange(0, 9);
    return AnchorFieldNullableU64(index: index, name: name, value: result);
  }

  static AnchorFieldNullableU64 factory() {
    return AnchorFieldNullableU64(index: 0, name: '', value: null);
  }
}

class AnchorFieldI64 extends AnchorField<int> {
  final int value;

  AnchorFieldI64({
    required int index,
    required String name,
    required this.value
  }) : super(index: index, name: name);

  @override
  Uint8List serialize() {
    return toLEByteArray(value, 8);
  }

  @override
  AnchorFieldU64 deserialize(List<int> bytes) {
    int result = fromLEByteArray(Uint8List.fromList(bytes.sublist(0, 8)));
    bytes.removeRange(0, 8);
    return AnchorFieldU64(index: index, name: name, value: result);
  }

  static AnchorFieldU64 factory() {
    return AnchorFieldU64(index: 0, name: '', value: 0);
  }
}

class AnchorFieldNullableI64 extends AnchorField<int?> {
  final int? value;

  AnchorFieldNullableI64({
    required int index,
    required String name,
    required this.value
  }) : super(index: index, name: name);

  @override
  Uint8List serialize() {
    if (value == null) {
      return Uint8List(0);
    }

    return toLEByteArray(value!, 8);
  }

  @override
  AnchorFieldNullableU64 deserialize(List<int> bytes) {
    if (bytes.isEmpty) {
      throw Exception('Empty byte array provided');
    }

    if (bytes.first == 0) {
      return AnchorFieldNullableU64(index: index, name: name, value: null);
    }

    if (bytes.first != 1) {
      throw Exception('Invalid bytes');
    }

    if (bytes.length < 9) {
      throw Exception('Insufficient bytes for length field');
    }

    int result = fromLEByteArray(Uint8List.fromList(bytes.sublist(1, 9)));
    bytes.removeRange(0, 9);
    return AnchorFieldNullableU64(index: index, name: name, value: result);
  }

  static AnchorFieldNullableU64 factory() {
    return AnchorFieldNullableU64(index: 0, name: '', value: null);
  }
}

class AnchorFieldU32 extends AnchorField<int> {
  final int value;

  AnchorFieldU32({
    required int index,
    required String name,
    required this.value
  }) : super(index: index, name: name);

  @override
  Uint8List serialize() {
    return toLEByteArray(value, 4);
  }

  @override
  AnchorFieldU32 deserialize(List<int> bytes) {
    int result = fromLEByteArray(Uint8List.fromList(bytes.sublist(0, 4)));
    bytes.removeRange(0, 4);
    return AnchorFieldU32(index: index, name: name, value: result);
  }

  static AnchorFieldU32 factory() {
    return AnchorFieldU32(index: 0, name: '', value: 0);
  }
}

class AnchorFieldNullableU32 extends AnchorField<int?> {
  final int? value;

  AnchorFieldNullableU32({
    required int index,
    required String name,
    required this.value
  }) : super(index: index, name: name);

  @override
  Uint8List serialize() {
    if (value == null) {
      return Uint8List(0);
    }

    return toLEByteArray(value!, 4);
  }

  @override
  AnchorFieldNullableU32 deserialize(List<int> bytes) {
    if (bytes.isEmpty) {
      throw Exception('Empty byte array provided');
    }

    if (bytes.first == 0) {
      return AnchorFieldNullableU32(index: index, name: name, value: null);
    }

    if (bytes.first != 1) {
      throw Exception('Invalid bytes');
    }

    if (bytes.length < 5) {
      throw Exception('Insufficient bytes for length field');
    }

    int result = fromLEByteArray(Uint8List.fromList(bytes.sublist(1, 5)));
    bytes.removeRange(0, 5);
    return AnchorFieldNullableU32(index: index, name: name, value: result);
  }

  static AnchorFieldNullableU32 factory() {
    return AnchorFieldNullableU32(index: 0, name: '', value: null);
  }
}

class AnchorFieldU16 extends AnchorField<int> {
  final int value;

  AnchorFieldU16({
    required int index,
    required String name,
    required this.value
  }) : super(index: index, name: name);

  @override
  Uint8List serialize() {
    return toLEByteArray(value, 2);
  }

  @override
  AnchorFieldU16 deserialize(List<int> bytes) {
    int result = fromLEByteArray(Uint8List.fromList(bytes.sublist(0, 2)));
    bytes.removeRange(0, 2);
    return AnchorFieldU16(index: index, name: name, value: result);
  }

  static AnchorFieldU16 factory() {
    return AnchorFieldU16(index: 0, name: '', value: 0);
  }
}

class AnchorFieldNullableU16 extends AnchorField<int?> {
  final int? value;

  AnchorFieldNullableU16({
    required int index,
    required String name,
    required this.value
  }) : super(index: index, name: name);

  @override
  Uint8List serialize() {
    if (value == null) {
      return Uint8List(0);
    }

    return toLEByteArray(value!, 2);
  }

  @override
  AnchorFieldNullableU16 deserialize(List<int> bytes) {
    if (bytes.isEmpty) {
      throw Exception('Empty byte array provided');
    }

    if (bytes.first == 0) {
      return AnchorFieldNullableU16(index: index, name: name, value: null);
    }

    if (bytes.first != 1) {
      throw Exception('Invalid bytes');
    }

    if (bytes.length < 3) {
      throw Exception('Insufficient bytes for length field');
    }

    int result = fromLEByteArray(Uint8List.fromList(bytes.sublist(1, 3)));
    bytes.removeRange(0, 3);
    return AnchorFieldNullableU16(index: index, name: name, value: result);
  }

  static AnchorFieldNullableU16 factory() {
    return AnchorFieldNullableU16(index: 0, name: '', value: null);
  }
}

class AnchorFieldU8 extends AnchorField<int> {
  final int value;

  AnchorFieldU8({
    required int index,
    required String name,
    required this.value
  }) : super(index: index, name: name);

  @override
  Uint8List serialize() {
    return toLEByteArray(value, 1);
  }

  @override
  AnchorFieldU8 deserialize(List<int> bytes) {
    int result = fromLEByteArray(Uint8List.fromList(bytes.sublist(0, 1)));
    bytes.removeRange(0, 1);
    return AnchorFieldU8(index: index, name: name, value: result);
  }

  static AnchorFieldU8 factory() {
    return AnchorFieldU8(index: 0, name: '', value: 0);
  }
}

class AnchorFieldNullableU8 extends AnchorField<int?> {
  final int? value;

  AnchorFieldNullableU8({
    required int index,
    required String name,
    required this.value
  }) : super(index: index, name: name);

  @override
  Uint8List serialize() {
    if (value == null) {
      return Uint8List(0);
    }

    return toLEByteArray(value!, 1);
  }

  @override
  AnchorFieldNullableU8 deserialize(List<int> bytes) {
    if (bytes.isEmpty) {
      throw Exception('Empty byte array provided');
    }

    if (bytes.first == 0) {
      return AnchorFieldNullableU8(index: index, name: name, value: null);
    }

    if (bytes.first != 1) {
      throw Exception('Invalid bytes');
    }

    if (bytes.length < 2) {
      throw Exception('Insufficient bytes for length field');
    }

    int result = fromLEByteArray(Uint8List.fromList(bytes.sublist(1, 2)));
    bytes.removeRange(0, 2);
    return AnchorFieldNullableU8(index: index, name: name, value: result);
  }

  static AnchorFieldNullableU8 factory() {
    return AnchorFieldNullableU8(index: 0, name: '', value: null);
  }
}

class AnchorFieldBytes extends AnchorField<Uint8List> {
  final Uint8List value;

  AnchorFieldBytes({
    required int index,
    required String name,
    required this.value
  }) : super(index: index, name: name);

  @override
  Uint8List serialize() {
    Uint8List lengthBytes = toLEByteArray(value.length, 4);
    return Uint8List.fromList([
      ...lengthBytes,
      ...value
    ]);
  }

  @override
  AnchorFieldBytes deserialize(List<int> bytes) {
    Uint8List result = Uint8List.fromList(bytes.sublist(0, 32));
    bytes.removeRange(0, 32);
    return AnchorFieldBytes(index: index, name: name, value: result);
  }

  static AnchorFieldBytes factory() {
    return AnchorFieldBytes(index: 0, name: '', value: Uint8List(0));
  }
}

class AnchorFieldNullableBytes extends AnchorField<Uint8List?> {
  final Uint8List? value;

  AnchorFieldNullableBytes({
    required int index,
    required String name,
    required this.value
  }) : super(index: index, name: name);

  @override
  Uint8List serialize() {
    if (value == null) {
      return Uint8List(0);
    }

    Uint8List lengthBytes = toLEByteArray(value!.length, 4);
    return Uint8List.fromList([
      ...lengthBytes,
      ...value!
    ]);
  }

  @override
  AnchorFieldNullableBytes deserialize(List<int> bytes) {
    if (bytes.isEmpty) {
      throw Exception('Empty byte array provided');
    }

    if (bytes.first == 0) {
      return AnchorFieldNullableBytes(index: index, name: name, value: null);
    }

    if (bytes.first != 1) {
      throw Exception('Invalid bytes');
    }

    if (bytes.length < 33) {
      throw Exception('Insufficient bytes for length field');
    }

    Uint8List result = Uint8List.fromList(bytes.sublist(1, 33));
    bytes.removeRange(0, 33);
    return AnchorFieldNullableBytes(index: index, name: name, value: result);
  }

  static AnchorFieldNullableBytes factory() {
    return AnchorFieldNullableBytes(index: 0, name: '', value: null);
  }
}

class AnchorFieldPublicKey extends AnchorField<Uint8List> {
  final Uint8List value;

  AnchorFieldPublicKey({
    required int index,
    required String name,
    required this.value
  }) : super(index: index, name: name);

  @override
  Uint8List serialize() {
    Uint8List lengthBytes = toLEByteArray(value.length, 4);
    return Uint8List.fromList([
      ...lengthBytes,
      ...value
    ]);
  }

  @override
  AnchorFieldPublicKey deserialize(List<int> bytes) {
    Uint8List result = Uint8List.fromList(bytes.sublist(0, 32));
    bytes.removeRange(0, 32);
    return AnchorFieldPublicKey(index: index, name: name, value: result);
  }

  static AnchorFieldPublicKey factory() {
    return AnchorFieldPublicKey(index: 0, name: '', value: Uint8List(0));
  }
}

class AnchorFieldNullablePublicKey extends AnchorField<Uint8List?> {
  final Uint8List? value;

  AnchorFieldNullablePublicKey({
    required int index,
    required String name,
    required this.value
  }) : super(index: index, name: name);

  @override
  Uint8List serialize() {
    if (value == null) {
      return Uint8List(0);
    }

    Uint8List lengthBytes = toLEByteArray(value!.length, 4);
    return Uint8List.fromList([
      ...lengthBytes,
      ...value!
    ]);
  }

  @override
  AnchorFieldNullablePublicKey deserialize(List<int> bytes) {
    if (bytes.isEmpty) {
      throw Exception('Empty byte array provided');
    }

    if (bytes.first == 0) {
      return AnchorFieldNullablePublicKey(index: index, name: name, value: null);
    }

    if (bytes.first != 1) {
      throw Exception('Invalid bytes');
    }

    if (bytes.length < 33) {
      throw Exception('Insufficient bytes for length field');
    }

    Uint8List result = Uint8List.fromList(bytes.sublist(1, 33));
    bytes.removeRange(0, 33);
    return AnchorFieldNullablePublicKey(index: index, name: name, value: result);
  }

  static AnchorFieldNullablePublicKey factory() {
    return AnchorFieldNullablePublicKey(index: 0, name: '', value: null);
  }
}

class AnchorFieldVector<T extends AnchorSerializable> extends AnchorField<T> {
  final List<T> value;

  AnchorFieldVector({
    required int index,
    required String name,
    required this.value
  }) : super(index: index, name: name);

  @override
  Uint8List serialize() {
    Uint8List lengthBytes = toLEByteArray(value.length, 4);
    return Uint8List.fromList([
      ...lengthBytes,
      ...value
          .map((e) => e.serialize())
          .toList().fold<Uint8List>(Uint8List(0), (previousValue, element) =>
          Uint8List.fromList([...previousValue, ...element]))
    ]);
  }

  @override
  AnchorFieldVector<T> deserialize(List<int> bytes) {
    int resultLength = fromLEByteArray(Uint8List.fromList(bytes.sublist(0, 4)));
    bytes.removeRange(0, 4);

    List<T> result = [];
    for (int i = 0; i < resultLength; i++) {
      final instance = serializationRegistry.getInstance(T);

      if (instance == null) {
        throw ArgumentError('Unknown type structure $T');
      }

      result.add(instance.deserialize(bytes) as T);
    }

    return AnchorFieldVector<T>(index: index, name: name, value: result);
  }

  static AnchorFieldVector<AnchorSerializable> factory<T>() {
    return AnchorFieldVector<AnchorSerializable>(index: 0, name: '', value: []);
  }
}

class AnchorFieldNullableVector<T extends AnchorSerializable> extends AnchorField<T> {
  final List<T>? value;

  AnchorFieldNullableVector({
    required int index,
    required String name,
    required this.value
  }) : super(index: index, name: name);

  @override
  Uint8List serialize() {
    if (value == null) {
      return Uint8List(0);
    }

    Uint8List lengthBytes = toLEByteArray(value!.length, 4);
    return Uint8List.fromList([
      ...lengthBytes,
      ...value!
          .map((e) => e.serialize())
          .toList().fold<Uint8List>(Uint8List(0), (previousValue, element) =>
          Uint8List.fromList([...previousValue, ...element]))
    ]);
  }

  @override
  AnchorFieldNullableVector<T> deserialize(List<int> bytes) {
    if (bytes.isEmpty) {
      throw Exception('Empty byte array provided');
    }

    if (bytes.first == 0) {
      return AnchorFieldNullableVector<T>(index: index, name: name, value: null);
    }

    if (bytes.first != 1) {
      throw Exception('Invalid bytes');
    }

    if (bytes.length < 33) {
      throw Exception('Insufficient bytes for length field');
    }

    int resultLength = fromLEByteArray(Uint8List.fromList(bytes.sublist(0, 4)));
    bytes.removeRange(0, 4);

    List<T> result = [];
    for (int i = 0; i < resultLength; i++) {
      final instance = serializationRegistry.getInstance(T);

      if (instance == null) {
        throw ArgumentError('Unknown type structure $T');
      }

      result.add(instance.deserialize(bytes) as T);
    }

    return AnchorFieldNullableVector<T>(index: index, name: name, value: result);
  }

  static AnchorFieldVector<AnchorSerializable> factory<T>() {
    return AnchorFieldVector<AnchorSerializable>(index: 0, name: '', value: []);
  }
}

class AnchorFieldStruct<T extends AnchorStruct> extends AnchorField<T> {
  final T value;

  AnchorFieldStruct({
    required int index,
    required String name,
    required this.value
  }) : super(index: index, name: name);

  @override
  Uint8List serialize() {
    return Uint8List.fromList(value.serialize());
  }

  @override
  AnchorFieldStruct<T> deserialize(List<int> bytes) {
    var instance = serializationRegistry.getInstance(T);

    if (instance == null) {
      throw ArgumentError('Unknown type structure $T');
    }

    return AnchorFieldStruct(
        index: index, name: name, value: instance.deserialize(bytes) as T);
  }

  static AnchorFieldStruct<AnchorStruct> factory<T>() {
    return AnchorFieldStruct<AnchorStruct>(
        index: 0, name: '', value: AnchorStruct(name: '', fields: {}, ));
  }
}

class AnchorFieldNullableStruct<T extends AnchorStruct> extends AnchorField<T> {
  final T? value;

  AnchorFieldNullableStruct({
    required int index,
    required String name,
    required this.value
  }) : super(index: index, name: name);

  @override
  Uint8List serialize() {
    if (value == null) {
      return Uint8List(0);
    }

    return Uint8List.fromList(value!.serialize());
  }

  @override
  AnchorFieldStruct<T> deserialize(List<int> bytes) {
    var instance = serializationRegistry.getInstance(T);

    if (instance == null) {
      throw ArgumentError('Unknown type structure $T');
    }

    return AnchorFieldStruct(
        index: index, name: name, value: instance.deserialize(bytes) as T);
  }

  static AnchorFieldStruct<AnchorStruct> factory<T>() {
    return AnchorFieldStruct<AnchorStruct>(
        index: 0, name: '', value: AnchorStruct(name: '', fields: {}, ));
  }
}

class AnchorFieldEnum<T extends AnchorEnum> extends AnchorField<T> {
  final T value;

  AnchorFieldEnum({
    required int index,
    required String name,
    required this.value
  }) : super(index: index, name: name);

  @override
  Uint8List serialize() {
    return Uint8List.fromList(value.serialize());
  }

  @override
  AnchorFieldEnum<T> deserialize(List<int> bytes) {
    if (bytes.isEmpty) {
      throw Exception("Data is empty, cannot deserialize.");
    }

    var instance = serializationRegistry.getInstance(T);

    if (instance == null) {
      throw ArgumentError('Unknown type structure $T');
    }

    return AnchorFieldEnum(
        index: index, name: name, value: instance.deserialize(bytes) as T);
  }

  static AnchorFieldEnum<AnchorEnum> factory<T>() {
    return AnchorFieldEnum<AnchorEnum>(
        index: 0, name: '', value: AnchorEnum(value: AnchorEnumDefault.DEFAULT));
  }
}

abstract class AnchorSerializable {
  List<int> serialize();
  AnchorSerializable deserialize(List<int> bytes);
}

enum AnchorEnumDefault { DEFAULT; }