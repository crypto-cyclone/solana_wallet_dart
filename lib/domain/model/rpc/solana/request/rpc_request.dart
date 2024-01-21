abstract class RPCRequest {
  final String jsonrpc;
  final int id;
  final String method;

  static const getLatestBlockHashMethodId = 1;
  static const getBalanceMethodId = 2;
  static const sendTransactionMethodId = 3;
  static const getTransactionMethodId = 4;
  static const getTokenAccountsByOwnerMethodId = 5;
  static const getAccountInfoMethodId = 6;
  static const getProgramAccountsId = 7;
  static const getBlockHeightMethodId = 8;

  static const getLatestBlockHashRPCMethod = "getLatestBlockhash";
  static const getBalanceRPCMethod = "getBalance";
  static const sendTransactionRPCMethod = "sendTransaction";
  static const getTransactionRPCMethod = "getTransaction";
  static const getTokenAccountsByOwnerRPCMethod = "getTokenAccountsByOwner";
  static const getAccountInfoRPCMethod = "getAccountInfo";
  static const getProgramAccountsRPCMethod = "getProgramAccounts";
  static const getBlockHeightRPCMethod = "getBlockHeight";

  RPCRequest({
    this.jsonrpc = "2.0",
    required this.id,
    required this.method
  });

  String toJson() {
    throw UnimplementedError("toJson() is not implemented");
  }
}