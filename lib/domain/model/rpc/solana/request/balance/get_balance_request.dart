import 'package:solana_wallet/domain/model/rpc/solana/request/rpc_request.dart';

class GetBalanceRequest extends RPCRequest {
  final String address;
  final String commitment;
  int? minContextSlot;

  GetBalanceRequest({
    required this.address,
    this.commitment = "finalized",
    this.minContextSlot = null,
    super.id = RPCRequest.getBalanceMethodId,
    super.method = RPCRequest.getBalanceRPCMethod,
  });

  @override
  String toJson() {
    return '{"jsonrpc":"$jsonrpc","id":$id,"method":"$method","params":["$address",{"commitment":"$commitment"${(minContextSlot != null ? ',"minContextSlot":$minContextSlot' : '')}}]}';
  }
}