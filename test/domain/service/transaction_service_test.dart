import 'package:hex/hex.dart';
import 'package:solana_wallet/domain/service/transaction_service.dart';
import 'package:solana_wallet/constants/solana/unit.dart';
import 'package:test/test.dart';

void main() {
  group('TransactionService', () {

    late TransactionService transactionService;

    setUp(() {
      transactionService = TransactionService();
    });

    test('createTransaction', () {
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
  });
}