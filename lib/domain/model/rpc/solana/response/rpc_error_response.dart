import 'package:solana_wallet/domain/model/rpc/solana/request/rpc_request.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/rpc_error.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/rpc_response.dart';

class RPCErrorResponse extends RPCResponse {
  RPCErrorResponse({
    required super.jsonrpc,
    required super.id,
    required super.method,
    required super.error
  });

  static RPCErrorResponse fromRequest(RPCRequest request) {
    return RPCErrorResponse(
      jsonrpc: request.jsonrpc,
      id: request.id,
      method: request.method,
      error: null,
    );
  }

  static RPCErrorResponse fromJson(Map<String, dynamic> json) {
    String jsonrpc = json['jsonrpc'] as String;
    int id = json['id'] as int;
    String? method = json['method'] as String?;
    RPCError error = RPCError.fromJson(json['error'] as Map<String, dynamic>);

    return RPCErrorResponse(
      jsonrpc: jsonrpc,
      id: id,
      method: method,
      error: error,
    );
  }

  @override
  String toJson() {
    throw UnimplementedError();
  }
}