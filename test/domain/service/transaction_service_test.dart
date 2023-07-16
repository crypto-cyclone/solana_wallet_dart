import 'dart:typed_data';
import 'package:hex/hex.dart';
import 'package:solana_wallet/domain/model/encryption/solana/solana_keypair_model.dart';
import 'package:solana_wallet/domain/model/transaction/solana/transaction.dart';
import 'package:solana_wallet/domain/service/transaction_service.dart';
import 'package:solana_wallet/constants/solana/unit.dart';
import 'package:test/test.dart';

void main() {
  group('TransactionService', () {

    late TransactionService transactionService;

    setUp(() {
      transactionService = TransactionService();
    });

    test('createSolTokenTransferTransaction', () {
      var expectedUnsigned = "01000103bd284fde1526b7b936a76bde6d8955b6617e56a01e5d0309deda3c426e0a7ca00772d70525541e5247a942d8397ffed60e562cc1e8f0400c402f5469afb25ce80000000000000000000000000000000000000000000000000000000000000000c1538682c2fd5be655a37600257f416b893d47cd4a21148991279f668982f9a501020200010c0200000000ca9a3b00000000";

      var fromAddress = "DjPi1LtwrXJMAh2AUvuUMajCpMJEKg8N1J8fU4L2Xr9D";
      var toAddress = "W5RJACTF8t4TC1LSBr4SXqkuZkFMM8yZFvRqqfM6tqM";
      var blockhash = "E1fZFLAd1aB8xUG6mx4KuEfG4kNKXBY99W26o5RPbbvk";
      var lamports = BigInt.from(unitsPerSOL);

      var unsigned = transactionService.createSolTokenTransferTransaction(
          fromAddress,
          toAddress,
          blockhash,
          lamports
      );

      expect(unsigned.serialize(), HEX.decode(expectedUnsigned));
    });

    test('signSolTokenTransferTransaction', () async {
      var expectedSigned = "019354e433374eb6812735751607ffea1ddbf2f6671975a8d2381c0ec5a6085d025c28ec0c277ea4173b72ff72fbabbb2fcbc880745ac3f835f38f0312a804f20a01000103bd284fde1526b7b936a76bde6d8955b6617e56a01e5d0309deda3c426e0a7ca00772d70525541e5247a942d8397ffed60e562cc1e8f0400c402f5469afb25ce800000000000000000000000000000000000000000000000000000000000000006429e2e42f0eee010a9eccec2d5281c30ffcb4108adab5d9eb56cca6294c465b01020200010c0200000000ca9a3b00000000";

      var fromAddress = "DjPi1LtwrXJMAh2AUvuUMajCpMJEKg8N1J8fU4L2Xr9D";
      var toAddress = "W5RJACTF8t4TC1LSBr4SXqkuZkFMM8yZFvRqqfM6tqM";
      var blockhash = "7jzpE4VGyhXViUcA77UmfK8r4ApfCK3J4mtrJKGF7EiE";
      var lamports = BigInt.from(unitsPerSOL);

      var transaction = transactionService.createSolTokenTransferTransaction(
          fromAddress,
          toAddress,
          blockhash,
          lamports
      );
      
      var keyPair = await SolanaKeyPair.fromSecretKey(
          Uint8List.fromList(
              HEX.decode("6504dfdd333f83f0d62a4b5d65bfa04e98cda2613cd4b80d4cf0a837b1cf6fbe")
          )
      );

      Transaction signedTransaction = await transactionService.signTransaction(
          transaction, [keyPair]
      );

      expect(signedTransaction.serialize(), HEX.decode(expectedSigned));
    });
  });
}