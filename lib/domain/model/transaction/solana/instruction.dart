import 'dart:typed_data';
import 'package:solana_wallet/domain/model/transaction/solana/transaction_data.dart';
import 'package:solana_wallet/encoder/solana/solana_encoder.dart';

class Instruction {
  int programIdIndex;
  Uint8List accountIndices;
  InstructionData data;

  final SolanaEncoder _solanaEncoder = SolanaEncoder();

  Instruction({
    required this.programIdIndex,
    required this.accountIndices,
    required this.data,
  });

  Uint8List serialize() {
    List<int> programIdBytes = [programIdIndex];
    Uint8List accountIndicesCompactU16 = _solanaEncoder.encodeCompactArray(
        accountIndices.length
    );
    Uint8List accountIndicesBytes = accountIndices;
    Uint8List dataBytes = data.serialize();

    return Uint8List.fromList(
      programIdBytes + accountIndicesCompactU16 + accountIndicesBytes + dataBytes,
    );
  }
}
