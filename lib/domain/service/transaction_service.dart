import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:solana_wallet/constants/solana/program_library.dart';
import 'package:solana_wallet/domain/model/encryption/solana/solana_keypair_model.dart';
import 'package:solana_wallet/domain/model/transaction/solana/header.dart';
import 'package:solana_wallet/domain/model/transaction/solana/instruction.dart';
import 'package:solana_wallet/domain/model/transaction/solana/message.dart';
import 'package:solana_wallet/domain/model/transaction/solana/transaction.dart';
import 'package:solana_wallet/domain/model/transaction/solana/transfer/sol_token_transfer_instruction_data.dart';

class TransactionService {
  final _ed25519 = Ed25519();

  Transaction createSolTokenTransferTransaction(
      String fromAddress,
      String toAddress,
      String blockhash,
      BigInt lamports) {

    Header header = Header(
        noSigs: 1,
        noSignedReadOnlyAccounts: 0,
        noUnsignedReadOnlyAccounts: 1
    );

    Instruction instruction = Instruction(
        programIdIndex: 2,
        accountIndices: Uint8List.fromList([0, 1]),
        data: SOLTokenTransferInstructionData(lamports: lamports)
    );

    Message message = Message(
        header: header,
        accountAddresses: [
          fromAddress,
          toAddress,
          systemProgram,
        ],
        blockhash: blockhash,
        instructions: [instruction]
    );

    return Transaction(message: message);
  }

  Future<Transaction> signTransaction(
      Transaction transaction,
      List<SolanaKeyPair> keyPairs
  ) async {
    transaction.noSignatures = 0;
    transaction.signatures = Uint8List(0);

    for (var keyPair in keyPairs) {
      var signature = await _ed25519.sign(
          transaction.message.serialize(),
          keyPair: await keyPair.toKeyPair()
      );
      transaction.signatures = Uint8List.fromList(
          transaction.signatures.toList() + signature.bytes
      );
      transaction.noSignatures++;
    }

    return transaction;
  }
}