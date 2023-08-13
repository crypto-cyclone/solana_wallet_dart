import 'rpc_response.dart';

class RPCSuccessResponse extends RPCResponse {
  RPCSuccessResponse({
    required super.jsonrpc,
    required super.id,
    super.method,
    required super.result
  });

  @override
  String toJson() {
    throw UnimplementedError();
  }
}