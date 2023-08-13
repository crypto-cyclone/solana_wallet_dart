import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class HttpService {
  Future<http.Response> post(Uri url, { Map<String, String>? headers, Object? body, Encoding? encoding});
}