import 'package:solana_wallet/api/idl/anchor_idl.dart';

class AnchorIDLSerializationRegistry {
  final Map<Type, AnchorSerializable Function()> _registry = {};
  bool _initialized = false;

  AnchorIDLSerializationRegistry._internal();

  static final AnchorIDLSerializationRegistry _singleton = AnchorIDLSerializationRegistry._internal();

  factory AnchorIDLSerializationRegistry() {
    return _singleton;
  }

  void register<T extends AnchorSerializable>(AnchorSerializable Function() factoryFn) {
    _registry[T] = factoryFn;
  }

  AnchorSerializable? getInstance(Type T) {
    final factoryFn = _registry[T];
    return factoryFn?.call();
  }

  void initialize() {
    if (_initialized) {
      return;
    }

    register<AnchorFieldString>(() => AnchorFieldString.factory());
    register<AnchorFieldNullableString>(() => AnchorFieldNullableString.factory());
    register<AnchorFieldU8>(() => AnchorFieldU8.factory());
    register<AnchorFieldNullableU8>(() => AnchorFieldNullableU8.factory());
    register<AnchorFieldU16>(() => AnchorFieldU16.factory());
    register<AnchorFieldNullableU16>(() => AnchorFieldU16.factory());
    register<AnchorFieldU32>(() => AnchorFieldU32.factory());
    register<AnchorFieldNullableU32>(() => AnchorFieldNullableU32.factory());
    register<AnchorFieldU64>(() => AnchorFieldU64.factory());
    register<AnchorFieldNullableU64>(() => AnchorFieldNullableU64.factory());
    register<AnchorFieldBytes>(() => AnchorFieldBytes.factory());
    register<AnchorFieldNullableBytes>(() => AnchorFieldNullableBytes.factory());
    register<AnchorFieldVector>(() => AnchorFieldVector.factory());

    _initialized = true;
  }
}

final serializationRegistry = AnchorIDLSerializationRegistry()..initialize();
