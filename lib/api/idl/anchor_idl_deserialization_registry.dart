import 'package:solana_wallet/api/idl/anchor_idl.dart';

class AnchorIDLDeserializationRegistry {
  final Map<Type, AnchorDeserializable Function()> _registry = {};
  bool _initialized = false;

  AnchorIDLDeserializationRegistry._internal();

  static final AnchorIDLDeserializationRegistry _singleton = AnchorIDLDeserializationRegistry._internal();

  factory AnchorIDLDeserializationRegistry() {
    return _singleton;
  }

  void register<T extends AnchorDeserializable>(AnchorDeserializable Function() factoryFn) {
    _registry[T] = factoryFn;
  }

  AnchorDeserializable? getInstance(Type T) {
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

final deserializationRegistry = AnchorIDLDeserializationRegistry()..initialize();
