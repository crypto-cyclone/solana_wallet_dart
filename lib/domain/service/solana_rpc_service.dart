import 'dart:convert';

import 'package:solana_wallet/api/service/http_service.dart';
import 'package:solana_wallet/domain/configuration/solana_configuration.dart';
import 'package:solana_wallet/domain/model/rpc/solana/request/get_account_info_request.dart';
import 'package:solana_wallet/domain/model/rpc/solana/request/send_transaction_request.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/account_info/get_account_info_response.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/rpc_error_response.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/rpc_response.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/send_transaction/send_transaction_response.dart';

class SolanaRPCService {
  final HttpService httpService;
  final SolanaConfiguration configuration;

  SolanaRPCService({
    required this.httpService,
    required this.configuration
  });

  Future<RPCResponse> getAccountInfo(GetAccountInfoRequest request) async {
    Uri uri = Uri.https(configuration.url, "/");

    final response = await httpService.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson())
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

  Future<RPCResponse> sendTransaction(SendTransactionRequest request) async {
    Uri uri = Uri.https(configuration.url, "/");

    final response = await httpService.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson())
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonMap = jsonDecode(response.body);

      if (jsonMap["error"] != null) {
        return RPCErrorResponse.fromJson(jsonMap);
      } else {
        return SendTransactionResponse.fromJson(jsonMap);
      }
    } else {
      return RPCErrorResponse.fromRequest(request);
    }
  }
}