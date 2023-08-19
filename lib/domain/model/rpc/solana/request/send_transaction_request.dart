import 'dart:convert';

import 'package:solana_wallet/domain/model/rpc/solana/request/rpc_request.dart';

class SendTransactionRequest extends RPCRequest {
  final List<String> transactions;

  SendTransactionRequest({
    required this.transactions,
    super.jsonrpc = "2.0",
    super.id = RPCRequest.sendTransactionMethodId,
    super.method = RPCRequest.sendTransactionRPCMethod
  });

  @override
  String toJson() {
    return '{"jsonrpc":"$jsonrpc","id":$id,"method":"$method","params":${jsonEncode(transactions)}}';
  }
}