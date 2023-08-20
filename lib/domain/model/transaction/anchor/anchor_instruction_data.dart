import 'dart:typed_data';

import 'package:solana_wallet/api/idl/anchor_idl.dart';
import 'package:solana_wallet/domain/model/transaction/solana/transaction_data.dart';
import 'package:solana_wallet/encoder/solana/solana_encoder.dart';

class AnchorInstructionData extends InstructionData {
  final Uint8List discriminator;
  final List<AnchorField> args;

  AnchorInstructionData({
    required this.discriminator,
    required this.args
  });

  final SolanaEncoder _solanaEncoder = SolanaEncoder();

  @override
  Uint8List serialize() {
    int size = discriminator.length;
    Uint8List bytes = Uint8List.fromList([...discriminator]);

    args.forEach((element) {
      var elementBytes = element.serialize();

      size += elementBytes.length;
      bytes = Uint8List.fromList([...bytes, ...elementBytes]);
    });

    Uint8List compactU16 =_solanaEncoder.encodeCompactArray(size);

    return Uint8List.fromList([...compactU16, ...bytes]);
  }
}