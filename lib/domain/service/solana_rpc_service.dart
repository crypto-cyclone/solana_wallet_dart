import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:solana_wallet/api/service/http_service.dart';
import 'package:solana_wallet/domain/configuration/solana_configuration.dart';
import 'package:solana_wallet/domain/model/rpc/solana/request/account_info/get_account_info_request.dart';
import 'package:solana_wallet/domain/model/rpc/solana/request/balance/get_balance_request.dart';
import 'package:solana_wallet/domain/model/rpc/solana/request/block_height/get_block_height_request.dart';
import 'package:solana_wallet/domain/model/rpc/solana/request/latest_blockhash/get_latest_blockhash_request.dart';
import 'package:solana_wallet/domain/model/rpc/solana/request/program_account/get_program_accounts_request.dart';
import 'package:solana_wallet/domain/model/rpc/solana/request/send_transaction/send_transaction_request.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/account_info/get_account_info_response.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/balance/get_balance_response.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/block_height/get_block_height_response.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/latest_blockhash/get_latest_blockhash_response.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/program_account/get_program_accounts_response.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/rpc_error_response.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/rpc_response.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/send_transaction/send_transaction_response.dart';

class SolanaRPCService {
  final _logger = Logger('SolanaRPCService');

  final HttpService httpService;
  final SolanaConfiguration configuration;
  final bool ssl;

  late final Uri uri;

  SolanaRPCService({
    required this.httpService,
    required this.configuration,
    this.ssl = true
  }) {
    if (ssl) {
      uri = Uri.https(configuration.url, "/");
    } else {
      uri = Uri.http(configuration.url, "/");
    }
  }

  Future<RPCResponse> getBlockHeight(GetBlockHeightRequest request) async {
    final response = await httpService.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: request.toJson()
    );

    if (response.statusCode == 200) {
      List<String> bigIntFields = [];

      Map<String, dynamic> jsonMap = _postprocessJson(
          jsonDecode(
              _preprocessJson(
                  response.body,
                  bigIntFields
              )
          ),
          bigIntFields
      );

      if (jsonMap["error"] != null) {
        _logger.severe(jsonMap);
        return RPCErrorResponse.fromJson(jsonMap);
      } else {
        return GetBlockHeightResponse.fromJson(jsonMap);
      }
    } else {
      return RPCErrorResponse.fromRequest(request);
    }
  }

  Future<RPCResponse> getLatestBlockhash(GetLatestBlockhashRequest request) async {
    final response = await httpService.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: request.toJson()
    );

    if (response.statusCode == 200) {
      var bigIntFields = [
        'lamports',
        'space',
        'rentEpoch'
      ];

      Map<String, dynamic> jsonMap = _postprocessJson(
          jsonDecode(
              _preprocessJson(
                  response.body,
                  bigIntFields
              )
          ),
          bigIntFields
      );

      if (jsonMap["error"] != null) {
        _logger.severe(jsonMap);
        return RPCErrorResponse.fromJson(jsonMap);
      } else {
        return GetLatestBlockhashResponse.fromJson(jsonMap);
      }
    } else {
      return RPCErrorResponse.fromRequest(request);
    }
  }

  Future<RPCResponse> getBalance(GetBalanceRequest request) async {
    final response = await httpService.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: request.toJson()
    );

    if (response.statusCode == 200) {
      var bigIntFields = ['value'];

      Map<String, dynamic> jsonMap = _postprocessJson(
          jsonDecode(
              _preprocessJson(
                  response.body,
                  bigIntFields
              )
          ),
          bigIntFields
      );

      if (jsonMap["error"] != null) {
        _logger.severe(jsonMap);
        return RPCErrorResponse.fromJson(jsonMap);
      } else {
        return GetBalanceResponse.fromJson(jsonMap);
      }
    } else {
      return RPCErrorResponse.fromRequest(request);
    }
  }

  Future<RPCResponse> getProgramAccounts(GetProgramAccountsRequest request) async {
    final response = await httpService.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: request.toJson()
    );

    if (response.statusCode == 200) {
      var bigIntFields = [
        'lamports',
        'space',
        'rentEpoch'
      ];

      Map<String, dynamic> jsonMap = _postprocessJson(
          jsonDecode(
              _preprocessJson(
                  response.body,
                  bigIntFields
              )
          ),
          bigIntFields
      );

      if (jsonMap["error"] != null) {
        _logger.severe(jsonMap);
        return RPCErrorResponse.fromJson(jsonMap);
      } else {
        return GetProgramAccountsResponse.fromJson(jsonMap);
      }
    } else {
      return RPCErrorResponse.fromRequest(request);
    }
  }

  Future<RPCResponse> getAccountInfo(GetAccountInfoRequest request) async {
    final response = await httpService.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: request.toJson()
    );

    if (response.statusCode == 200) {
      var bigIntFields = [
        'lamports',
        'space',
        'rentEpoch'
      ];

      Map<String, dynamic> jsonMap = _postprocessJson(
          jsonDecode(
              _preprocessJson(
                  response.body,
                  bigIntFields
              )
          ),
          bigIntFields
      );

      if (jsonMap["error"] != null) {
        _logger.severe(jsonMap);
        return RPCErrorResponse.fromJson(jsonMap);
      } else {
        return GetAccountInfoResponse.fromJson(jsonMap);
      }
    } else {
      return RPCErrorResponse.fromRequest(request);
    }
  }

  Future<RPCResponse> sendTransaction(SendTransactionRequest request) async {
    final response = await httpService.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: request.toJson()
    );

    if (response.statusCode == 200) {
      var bigIntFields = [
        'lamports',
        'space',
        'rentEpoch'
      ];

      Map<String, dynamic> jsonMap = _postprocessJson(
          jsonDecode(
              _preprocessJson(
                  response.body,
                  bigIntFields
              )
          ),
          bigIntFields
      );

      if (jsonMap["error"] != null) {
        _logger.severe(jsonMap);
        return RPCErrorResponse.fromJson(jsonMap);
      } else {
        return SendTransactionResponse.fromJson(jsonMap);
      }
    } else {
      return RPCErrorResponse.fromRequest(request);
    }
  }

  String _preprocessJson(String jsonString, List<String> bigIntFields) {
    for (var key in bigIntFields) {
      var regex = RegExp(r'"' + key + r'"\s*:\s*(\d+)');
      jsonString = jsonString.replaceAllMapped(regex, (match) {
        return '"$key": "${match[1]}"';
      });
    }
    return jsonString;
  }

  Map<String, dynamic> _postprocessJson(Map<String, dynamic> jsonMap, List<String> bigIntFields) {
    jsonMap.forEach((key, value) {
      if (bigIntFields.contains(key) && value is String) {
        jsonMap[key] = BigInt.parse(value);
      } else if (value is Map<String, dynamic>) {
        _postprocessJson(value, bigIntFields);
      } else if (value is List) {
        for (var element in value) {
          if (element is Map<String, dynamic>) {
            _postprocessJson(element, bigIntFields);
          }
        }
      }
    });

    return jsonMap;
  }
}