import 'package:solana_wallet/domain/model/rpc/solana/request/rpc_request.dart';

class GetProgramAccountsRequest extends RPCRequest {
  final String pubkey;
  final String commitment;
  final String encoding;
  int? minContextSlot;

  GetProgramAccountsRequest({
    required this.pubkey,
    this.commitment = "processed",
    this.encoding = 'base64',
    this.minContextSlot = null,
    super.jsonrpc = "2.0",
    super.id = RPCRequest.getProgramAccountsId,
    super.method = RPCRequest.getProgramAccountsRPCMethod,
  });

  @override
  String toJson() {
    if (minContextSlot != null) {
      return '{"jsonrpc":"$jsonrpc","id":$id,"method":"$method","params":["$pubkey",{"commitment":"$commitment","minContextSlot":$minContextSlot,"encoding":"$encoding"}]}';
    } else {
      return '{"jsonrpc":"$jsonrpc","id":$id,"method":"$method","params":["$pubkey",{"commitment":"$commitment","encoding":"$encoding"}]}';
    }
  }
}