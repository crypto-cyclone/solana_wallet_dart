import 'dart:convert';

import 'package:solana_wallet/api/service/http_service.dart';
import 'package:http/http.dart' as http;

class HttpServiceImpl extends HttpService {
  var responseJson = "";

  @override
  Future<http.Response> post(Uri url, { Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return Future(() => http.Response(responseJson, 200));
  }
}