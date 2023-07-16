import 'dart:typed_data';
import 'package:solana_wallet/constants/solana/system_instruction.dart';
import 'package:solana_wallet/domain/model/transaction/solana/transaction_data.dart';
import 'package:solana_wallet/encoder/solana/solana_encoder.dart';
import 'package:solana_wallet/util/byte_conversion.dart';

class SOLTokenTransferInstructionData extends InstructionData {

  BigInt lamports;

  SOLTokenTransferInstructionData({
    required this.lamports
  });

  final SolanaEncoder _solanaEncoder = SolanaEncoder();

  @override
  Uint8List serialize() {
    Uint8List functionIndexBytes = toLEByteArray(SystemInstruction.transfer.index, 4);
    Uint8List lamportsBytes = toLEByteArrayBigInt(lamports, 8);

    int size = functionIndexBytes.length + lamportsBytes.length;

    Uint8List compactU16 =_solanaEncoder.encodeCompactArray(size);

    return Uint8List.fromList(compactU16 + functionIndexBytes + lamportsBytes);
  }
}