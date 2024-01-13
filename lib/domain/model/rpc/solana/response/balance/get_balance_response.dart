import 'package:solana_wallet/domain/model/rpc/solana/response/rpc_result.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/rpc_success_response.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/context.dart';

class GetBalanceResponse extends RPCSuccessResponse {
  late final BigInt balance;
  late final Context? context;

  GetBalanceResponse({
    required super.jsonrpc,
    required super.id,
    required super.result
  }) {
    balance = result!.value;
    context = result?.context;
  }

  @override
  String toJson() {
    return '''
      {
        "jsonrpc": "$jsonrpc",
        "id": $id,
        ${method != null ? '"method": $method,' : ''}
        "result": $result
      }
    ''';
  }

  static GetBalanceResponse fromJson(Map<String, dynamic> json) {
    return GetBalanceResponse(
        jsonrpc: json['jsonrpc'],
        id: json['id'],
        result: RPCResult.fromJsonObject(json['result'])
    );
  }
}