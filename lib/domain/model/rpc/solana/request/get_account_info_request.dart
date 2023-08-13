import 'package:solana_wallet/domain/model/rpc/solana/request/rpc_request.dart';

class GetAccountInfoRequest extends RPCRequest {
  final String address;
  final String commitment;
  final String encoding;
  final String jsonRPC;

  final int id = RPCRequest.getAccountInfoMethodId;
  final String method = RPCRequest.getAccountInfoRPCMethod;

  GetAccountInfoRequest({
    required this.address,
    this.commitment = "finalized",
    this.encoding = "base64",
    this.jsonRPC = "2.0"
  });

  @override
  String toJson() {
    return '{"jsonrpc":"$jsonRPC","id":$id,"method":"$method","params":["$address",{"commitment":"$commitment","encoding":"$encoding"}]}';
  }
}