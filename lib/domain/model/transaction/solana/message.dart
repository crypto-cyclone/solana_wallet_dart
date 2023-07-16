import 'dart:typed_data';
import 'header.dart';
import 'instruction.dart';
import 'package:solana_wallet/encoder/solana/solana_encoder.dart';
import 'package:solana_wallet/encoder/base58/base_58_encoder.dart';

class Message {
  Header header;
  List<String> accountAddresses;
  String blockhash;
  List<Instruction> instructions;

  final SolanaEncoder _solanaEncoder = SolanaEncoder();
  final Base58Encoder _base58Encoder = Base58Encoder();

  Message({
    required this.header,
    required this.accountAddresses,
    required this.blockhash,
    required this.instructions,
  });

  Uint8List serialize() {
    Uint8List headerBytes = serializeHeader();
    Uint8List accountAddressesBytes = serializeAccountAddresses();
    Uint8List blockhashBytes = serializeBlockHash();
    Uint8List instructionsBytes = serializeInstructions();

    return Uint8List.fromList(headerBytes + accountAddressesBytes + blockhashBytes + instructionsBytes);
  }

  Uint8List serializeHeader() {
    return header.serialize();
  }

  Uint8List serializeAccountAddresses() {
    Uint8List compactU16 = _solanaEncoder.encodeCompactArray(accountAddresses.length);

    List<int> items = accountAddresses
        .map((it) => _base58Encoder.decodeBase58(it))
        .expand((it) => it)
        .toList();

    return Uint8List.fromList(compactU16 + items);
  }

  Uint8List serializeBlockHash() {
    return _base58Encoder.decodeBase58(blockhash);
  }

  Uint8List serializeInstructions() {
    Uint8List compactU16 = _solanaEncoder.encodeCompactArray(
        instructions.length
    );

    List<int> items = instructions
        .map((it) => it.serialize())
        .expand((it) => it)
        .toList();

    return Uint8List.fromList(compactU16 + items);
  }
}
