import 'package:solana_wallet/domain/model/rpc/solana/request/rpc_request.dart';

class GetAccountInfoRequest extends RPCRequest {
  final String address;
  final String commitment;
  final String encoding;

  GetAccountInfoRequest({
    required this.address,
    this.commitment = "finalized",
    this.encoding = "base64",
    super.jsonrpc = "2.0",
    super.id = RPCRequest.getAccountInfoMethodId,
    super.method = RPCRequest.getAccountInfoRPCMethod
  });

  @override
  String toJson() {
    return '{"jsonrpc":"$jsonrpc","id":$id,"method":"$method","params":["$address",{"commitment":"$commitment","encoding":"$encoding"}]}';
  }
}