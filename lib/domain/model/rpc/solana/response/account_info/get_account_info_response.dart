
import 'package:solana_wallet/domain/model/rpc/solana/response/rpc_result.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/rpc_success_response.dart';

import 'account_info.dart';

class GetAccountInfoResponse extends RPCSuccessResponse {
  late final AccountInfo accountInfo;

  GetAccountInfoResponse({
    required super.jsonrpc,
    required super.id,
    super.method,
    required super.result,
  }) {
    accountInfo = AccountInfo.fromJson(super.result!.value);
  }

  @override
  String toJson() {
    return """
      {
        "jsonrpc": "$jsonrpc",
        "id": $id,
        ${method != null ? "\"method\": $method," : ""}
        "result": ${accountInfo.toJson()}
      }
    """;
  }

  static GetAccountInfoResponse fromJson(Map<String, dynamic> json) {
    return GetAccountInfoResponse(
      jsonrpc: json['jsonrpc'] as String,
      id: json['id'] as int,
      method: json['method'] as String?,
      result: RPCResult.fromJson(json['result'] as Map<String, dynamic>),
    );
  }
}
