import 'dart:convert';

import 'package:solana_wallet/api/service/http_service.dart';
import 'package:http/http.dart' as http;

class HttpServiceImpl extends HttpService {
  @override
  Future<http.Response> post(Uri url, { Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return http.post(url, headers: headers, body: body, encoding: encoding);
  }
}