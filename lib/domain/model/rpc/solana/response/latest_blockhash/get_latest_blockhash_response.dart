import 'package:solana_wallet/domain/model/rpc/solana/response/context.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/latest_blockhash/blockhash.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/rpc_result.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/rpc_success_response.dart';

class GetLatestBlockhashResponse extends RPCSuccessResponse {
  late final Blockhash blockhash;
  late final Context? context;

  GetLatestBlockhashResponse({
    required super.jsonrpc,
    required super.id,
    super.method,
    required super.result,
  }) {
    blockhash = Blockhash.fromJson(result!.value);
    context = result?.context;
  }

  @override
  String toJson() {
    return '''
      {
        "jsonrpc": "$jsonrpc",
        "id": $id,
        ${method != null ? '"method": $method,' : ''}
        "result": ${blockhash.toJson()}
      }
    ''';
  }

  static GetLatestBlockhashResponse fromJson(Map<String, dynamic> json) {
    return GetLatestBlockhashResponse(
      jsonrpc: json['jsonrpc'] as String,
      id: json['id'] as int,
      method: json['method'] as String?,
      result: RPCResult.fromJson(json['result'] as Map<String, dynamic>),
    );
  }
}