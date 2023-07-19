import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:solana_wallet/domain/model/transaction/solana/message.dart';
import 'package:solana_wallet/encoder/solana/solana_encoder.dart';

class Transaction {
  int noSignatures;
  Uint8List signatures;
  late Message message;

  final SolanaEncoder _solanaEncoder = SolanaEncoder();
  final _ed25519 = Ed25519();

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

  Future<Transaction> signTransaction(List<SimpleKeyPair> keyPairs) async {
    for (var keyPair in keyPairs) {
      var signature = await _ed25519.sign(
          message.serialize(),
          keyPair: keyPair
      );
      signatures = Uint8List.fromList(
          signatures.toList() + signature.bytes
      );
      noSignatures++;
    }

    return this;
  }
}
