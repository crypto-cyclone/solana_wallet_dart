import 'rpc_error.dart';
import 'rpc_result.dart';

abstract class RPCResponse {
  final String jsonrpc;
  final int id;
  final String? method;
  final RPCResult? result;
  final RPCError? error;

  RPCResponse({
    required this.jsonrpc,
    required this.id,
    this.method,
    this.result,
    this.error
  });

  String toJson();
}