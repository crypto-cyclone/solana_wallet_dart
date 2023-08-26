import 'package:solana_wallet/domain/model/rpc/solana/request/rpc_request.dart';

class GetLatestBlockhashRequest extends RPCRequest {
  final String commitment;
  int? minContextSlot;

  GetLatestBlockhashRequest({
    this.commitment = "processed",
    this.minContextSlot = null,
    super.jsonrpc = "2.0",
    super.id = RPCRequest.getLatestBlockHashMethodId,
    super.method = RPCRequest.getLatestBlockHashRPCMethod
  });

  @override
  String toJson() {
    if (minContextSlot != null) {
      return '{"jsonrpc":"$jsonrpc","id":$id,"method":"$method","params":[{"commitment":"$commitment","minContextSlot":$minContextSlot}]}';
    } else {
      return '{"jsonrpc":"$jsonrpc","id":$id,"method":"$method","params":[{"commitment":"$commitment"}]}';
    }
  }
}