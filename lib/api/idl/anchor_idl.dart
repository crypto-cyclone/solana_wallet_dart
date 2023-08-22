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

import 'package:meta/meta.dart';

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

    return toTransactionUnsafe(programId, blockhash);
  }

  @visibleForTesting
  Transaction toTransactionUnsafe(String programId, String blockhash) {
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

class AnchorAccount {
  final String name;

  AnchorAccount({
    required this.name,
  });
}

class AnchorStruct {
  final String name;

  AnchorStruct({
    required this.name,
  });
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

class AnchorField<T> {
  final int index;
  final String name;

  AnchorField({
    required this.index,
    required this.name,
  });

  Uint8List serialize() {
    return Uint8List(0);
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
    Uint8List nameLengthBytes = toLEByteArray(value.length, 4);
    return Uint8List.fromList([
      ...nameLengthBytes,
      ...bytes
    ]);
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
      ...nameLengthBytes,
      ...bytes
    ]);
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
}

class AnchorFieldVector<T> extends AnchorField<T> {
  final List<T> value;

  AnchorFieldVector({
    required int index,
    required String name,
    required this.value
  }) : super(index: index, name: name);

  @override
  Uint8List serialize() {
    Uint8List lengthBytes = toLEByteArray(value.length, 4);
    if (value is AnchorField) {
      return Uint8List.fromList([
        ...lengthBytes,
        ...value.map((e) => e.serialize()).toList().fold<Uint8List>(
            Uint8List(0),
                (previousValue, element) => Uint8List.fromList([
              ...previousValue,
              ...element
            ])
        )
      ]);
    } else {
      throw ArgumentError('Unknown type structure');
    }
  }
}