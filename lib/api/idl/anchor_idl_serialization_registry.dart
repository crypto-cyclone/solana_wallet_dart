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

    _initialized = true;
  }
}

final serializationRegistry = AnchorIDLSerializationRegistry()..initialize();
