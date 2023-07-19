import 'dart:typed_data';

import 'package:solana_wallet/constants/solana/program_library.dart';
import 'package:solana_wallet/domain/model/transaction/solana/header.dart';
import 'package:solana_wallet/domain/model/transaction/solana/instruction.dart';
import 'package:solana_wallet/domain/model/transaction/solana/message.dart';
import 'package:solana_wallet/domain/model/transaction/solana/transaction.dart';
import 'package:solana_wallet/domain/model/transaction/solana/transfer/sol_token_transfer_instruction_data.dart';

class SOLTransferTransaction extends Transaction {
  SOLTransferTransaction(
      String fromAddress,
      String toAddress,
      String blockhash,
      BigInt lamports
  ): super(message: Message(
      header: Header(
          noSigs: 1,
          noSignedReadOnlyAccounts: 0,
          noUnsignedReadOnlyAccounts: 1
      ),
      accountAddresses: [
        fromAddress,
        toAddress,
        systemProgram,
      ],
      blockhash: blockhash,
      instructions: [
        Instruction(
            programIdIndex: 2,
            accountIndices: Uint8List.fromList([0, 1]),
            data: SOLTokenTransferInstructionData(lamports: lamports)
        )
      ]
  ));
}