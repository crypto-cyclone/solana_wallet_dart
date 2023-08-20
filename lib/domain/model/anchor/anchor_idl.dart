import 'dart:typed_data';

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
  final String name;
  final bool argsSet;
  final bool accountsSet;

  AnchorInstruction({
    required this.name,
    this.argsSet = false,
    this.accountsSet = false,
  });
}

class AnchorInstructionAccount {
  final String name;
  final bool isMut;
  final bool isSigner;
  final String address;

  AnchorInstructionAccount({
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
  final String name;

  AnchorField({
    required this.name,
  });

  AnchorField<T> withValue(T newValue) {
    return AnchorField<T>(name: name);
  }
}

class AnchorFieldString extends AnchorField<String> {
  final String value;

  AnchorFieldString({
    required String name,
    required this.value
  }) : super(name: name);

  @override
  AnchorFieldString withValue(String newValue) {
    return AnchorFieldString(name: name, value: newValue);
  }
}

class AnchorFieldNullableString extends AnchorField<String?> {
  final String? value;

  AnchorFieldNullableString({
    required String name,
    required this.value
  }) : super(name: name);

  @override
  AnchorFieldNullableString withValue(String? newValue) {
    return AnchorFieldNullableString(name: name, value: newValue);
  }
}

class AnchorFieldU64 extends AnchorField<int> {
  final int value;

  AnchorFieldU64({
    required String name,
    required this.value
  }) : super(name: name);

  @override
  AnchorFieldU64 withValue(int newValue) {
    return AnchorFieldU64(name: name, value: newValue);
  }
}

class AnchorFieldNullableU64 extends AnchorField<int?> {
  final int? value;

  AnchorFieldNullableU64({
    required String name,
    required this.value
  }) : super(name: name);

  @override
  AnchorFieldNullableU64 withValue(int? newValue) {
    return AnchorFieldNullableU64(name: name, value: newValue);
  }
}

class AnchorFieldU32 extends AnchorField<int> {
  final int value;

  AnchorFieldU32({
    required String name,
    required this.value
  }) : super(name: name);

  @override
  AnchorFieldU32 withValue(int newValue) {
    return AnchorFieldU32(name: name, value: newValue);
  }
}

class AnchorFieldNullableU32 extends AnchorField<int?> {
  final int? value;

  AnchorFieldNullableU32({
    required String name,
    required this.value
  }) : super(name: name);

  @override
  AnchorFieldNullableU32 withValue(int? newValue) {
    return AnchorFieldNullableU32(name: name, value: newValue);
  }
}

class AnchorFieldBytes extends AnchorField<Uint8List> {
  final Uint8List value;

  AnchorFieldBytes({
    required String name,
    required this.value
  }) : super(name: name);

  @override
  AnchorFieldBytes withValue(Uint8List newValue) {
    return AnchorFieldBytes(name: name, value: newValue);
  }
}

class AnchorFieldNullableBytes extends AnchorField<Uint8List?> {
  final Uint8List? value;

  AnchorFieldNullableBytes({
    required String name,
    required this.value
  }) : super(name: name);

  @override
  AnchorFieldNullableBytes withValue(Uint8List? newValue) {
    return AnchorFieldNullableBytes(name: name, value: newValue);
  }
}

class AnchorFieldVector<T> extends AnchorField<List<T>> {
  final List<T> value;

  AnchorFieldVector({
    required String name,
    required this.value
  }) : super(name: name);

  @override
  AnchorFieldVector<T> withValue(List<T> newValue) {
    return AnchorFieldVector<T> (name: name, value: newValue);
  }
}

class AnchorStruct {
  final String name;

  AnchorStruct({
    required this.name,
  });
}