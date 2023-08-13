import 'rpc_error.dart';
import 'rpc_success.dart';

abstract class RPCResponse {
  final String jsonRPC;
  final int id;
  final String method;
  final RPCSuccess? success;
  final RPCError? error;

  RPCResponse({
    required this.jsonRPC,
    required this.id,
    required this.method,
    this.success,
    this.error
  });
}