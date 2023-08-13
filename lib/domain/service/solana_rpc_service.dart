import 'dart:convert';

import 'package:solana_wallet/api/service/http_service.dart';
import 'package:solana_wallet/domain/model/rpc/solana/request/get_account_info_request.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/account_info/get_account_info_response.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/rpc_error_response.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/rpc_response.dart';

class SolanaRPCService {
  final HttpService httpService;

  SolanaRPCService({
    required this.httpService
  });

  Future<RPCResponse> getAccountInfo(GetAccountInfoRequest request) async {
    Uri uri = Uri.https("api.devnet.solana.com", "/");

    final response = await httpService.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonDecode(request.toJson())
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonMap = jsonDecode(response.body);

      if (jsonMap["error"] != null) {
        return RPCErrorResponse.fromJson(jsonMap);
      } else {
        return GetAccountInfoResponse.fromJson(jsonMap);
      }
    } else {
      return RPCErrorResponse.fromRequest(request);
    }
  }
}