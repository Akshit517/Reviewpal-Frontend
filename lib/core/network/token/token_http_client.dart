import 'dart:convert';

import 'package:http/http.dart' as http;

import 'token_manager.dart';
import 'token_refresher.dart';

class TokenHttpClient {
  final TokenManager tokenManager;
  final TokenRefresher tokenRefresher;
  final http.Client client;

  TokenHttpClient({
    required this.tokenManager,
    required this.tokenRefresher,
    required this.client,
  });

  Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    return _performRequest(() => client.get(Uri.parse(url), headers: headers));
  }

  Future<http.Response> post(String url, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    return _performRequest(() => client.post(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(body),
        ));
  }

  Future<http.Response> _performRequest(Future<http.Response> Function() request) async {
    String? token = await tokenManager.accessToken;

    if (token == null) {
      await tokenRefresher.refreshToken();
      token = await tokenManager.accessToken;
    }

    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await request().then(
        (req) => http.Response(req.body, req.statusCode, headers: {...req.headers, ...headers}),
      );

      if (response.statusCode == 401) {
        await tokenRefresher.refreshToken();
        token = await tokenManager.accessToken;

        final retryResponse = await request().then(
          (req) => http.Response(req.body, req.statusCode, headers: {...req.headers, ...headers}),
        );
        return retryResponse;
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
