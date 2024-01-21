import 'package:solana_wallet/domain/model/rpc/solana/response/rpc_result.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/rpc_success_response.dart';

class GetBlockHeightResponse extends RPCSuccessResponse {
  late final int blockheight;

  GetBlockHeightResponse({
    required super.jsonrpc,
    required super.id,
    super.method,
    required super.result,
  }) {
    blockheight = result!.value;
  }

  @override
  String toJson() {
    return '''
      {
        "jsonrpc": "$jsonrpc",
        "id": $id,
        ${method != null ? '"method": $method,' : ''}
        "result": ${blockheight}
      }
    ''';
  }

  static GetBlockHeightResponse fromJson(Map<String, dynamic> json) {
    return GetBlockHeightResponse(
      jsonrpc: json['jsonrpc'] as String,
      id: json['id'] as int,
      method: json['method'] as String?,
      result: RPCResult.fromJsonPrimitive(json['result']),
    );
  }
}