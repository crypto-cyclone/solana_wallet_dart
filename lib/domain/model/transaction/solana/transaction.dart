import 'dart:typed_data';

import 'package:solana_wallet/domain/model/transaction/solana/message.dart';
import 'package:solana_wallet/encoder/solana/solana_encoder.dart';

class Transaction {
  int noSignatures;
  Uint8List signatures;
  Message message;

  final SolanaEncoder _solanaEncoder = SolanaEncoder();

  Transaction({
    this.noSignatures = 0,
    required this.message,
    signatures
  }) : signatures = signatures ?? Uint8List(0);

  Uint8List serialize() {
    List<int> signaturesBytes = serializeSignatures();
    List<int> messageBytes = serializeMessage();

    return Uint8List.fromList(signaturesBytes + messageBytes);
  }

  List<int> serializeSignatures() {
    if (noSignatures > 0) {
      List<int> compactU16 = _solanaEncoder.encodeCompactArray(noSignatures);
      return compactU16 + signatures;
    } else {
      return Uint8List(0);
    }
  }

  List<int> serializeMessage() {
    return message.serialize();
  }
}
