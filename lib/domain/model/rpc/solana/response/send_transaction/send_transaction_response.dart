import 'package:solana_wallet/domain/model/rpc/solana/response/rpc_response.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/rpc_success_response.dart';

import '../rpc_result.dart';

class SendTransactionResponse extends RPCSuccessResponse {
  late final String transactionHash;

  SendTransactionResponse({
    required super.jsonrpc,
    required super.id,
    super.method,
    required super.result,
  }) {
    transactionHash = super.result!.value as String;
  }

  @override
  String toJson() {
    return """
        {
          "jsonrpc": "$jsonrpc",
          "id": $id,
          ${method != null ? "\"method\": $method," : ""}
          "result": $transactionHash
        }
      """;
  }

  static SendTransactionResponse fromJson(Map<String, dynamic> json) {
    return SendTransactionResponse(
      jsonrpc: json['jsonrpc'] as String,
      id: json['id'] as int,
      method: json['method'] as String?,
      result: RPCResult(value: json['result']),
    );
  }
}