import 'package:solana_wallet/domain/model/rpc/solana/response/program_account/program_account.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/rpc_result.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/rpc_success_response.dart';

class GetProgramAccountsResponse extends RPCSuccessResponse {
  late final List<ProgramAccount> programAccounts;

  GetProgramAccountsResponse({
    required super.jsonrpc,
    required super.id,
    super.method,
    required super.result,
  }) {
    programAccounts = [...super.result!.value.map((e) => ProgramAccount.fromJson(e))];
  }

  @override
  String toJson() {
    return '''
      {
        "jsonrpc": "$jsonrpc",
        "id": $id,
        ${method != null ? '"method": $method,' : ''}
        "result": [${programAccounts.join(',')}]
      }
    ''';
  }

  static GetProgramAccountsResponse fromJson(Map<String, dynamic> json) {
    return GetProgramAccountsResponse(
      jsonrpc: json['jsonrpc'] as String,
      id: json['id'] as int,
      method: json['method'] as String?,
      result: RPCResult.fromJsonList(json['result'] as List<dynamic>)
    );
  }
}