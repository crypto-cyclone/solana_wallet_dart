abstract class RPCRequest {
  static const getLatestBlockHashMethodId = 1;
  static const getBalanceMethodId = 2;
  static const sendTransactionMethodId = 3;
  static const getTransactionMethodId = 4;
  static const getTokenAccountsByOwnerMethodId = 5;
  static const getAccountInfoMethodId = 6;

  static const getLatestBlockHashRPCMethod = "getLatestBlockhash";
  static const getBalanceRPCMethod = "getBalance";
  static const sendTransactionRPCMethod = "sendTransaction";
  static const getTransactionRPCMethod = "getTransaction";
  static const getTokenAccountsByOwnerRPCMethod = "getTokenAccountsByOwner";
  static const getAccountInfoRPCMethod = "getAccountInfo";

  String toJson() {
    throw UnimplementedError("toJson() is not implemented");
  }
}