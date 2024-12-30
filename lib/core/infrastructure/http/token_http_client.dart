import 'dart:convert';
import 'package:http/http.dart' as http;

import 'token_manager.dart';
import 'token_refresher.dart';

class TokenHttpClient {
  final TokenManager tokenManager;
  final TokenRefresher tokenRefresher;
  final http.Client client;
  bool _isRefreshing = false;
  TokenHttpClient({
    required this.tokenManager,
    required this.tokenRefresher,
    required this.client,
  });

  Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    final getHeaders = await _prepareHeaders(headers);
    return _performRequest(
      () => client.get(
        Uri.parse(url),
        headers: getHeaders,
      ),
    );
  }

  Future<http.Response> post(
    String url,
    dynamic body, {
    Map<String, String>? headers,
  }) async {
    final getHeaders = await _prepareHeaders(headers);
    return _performRequest(
      () => client.post(
        Uri.parse(url),
        headers: getHeaders,
        body: jsonEncode(body),
      ),
    );
  }

  Future<http.Response> put(
    String url,
    dynamic body, {
    Map<String, String>? headers,
  }) async {
    final getHeaders = await _prepareHeaders(headers);
    return _performRequest(
      () => client.put(
        Uri.parse(url),
        headers: getHeaders,
        body: jsonEncode(body),
      ),
    );
  }

  Future<http.Response> delete(
    String url, 
    dynamic body, {
    Map<String, String>? headers,
  }) async {
    final getHeaders = await _prepareHeaders(headers);
    return _performRequest(
      () => client.delete(
        Uri.parse(url),
        headers: getHeaders,
        body: body != null ? jsonEncode(body) : null,
      ),
    );
  }

  Future<Map<String, String>> _prepareHeaders(Map<String, String>? additionalHeaders) async {
    String? token = await tokenManager.accessToken;
    
    if (token == null || await tokenManager.isTokenExpired()) {
      token = await _refreshTokenIfNeeded();
    }

    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      ...?additionalHeaders,
    };

    return headers;
  }

  Future<String?> _refreshTokenIfNeeded() async {
    if (_isRefreshing) {
      while (_isRefreshing) {
        Future.delayed(const Duration(milliseconds: 100));
      }
      return tokenManager.accessToken;
    }
    _isRefreshing = true;
    try {
      await tokenRefresher.refreshToken();
      return tokenManager.accessToken;
    } finally {
      _isRefreshing = false;
    }
  }

  Future<http.Response> _performRequest(
    Future<http.Response> Function() request,
  ) async {
    try {
      final response = await request(); 
      if (response.statusCode == 401) {
        final token = await _refreshTokenIfNeeded();
        if (token != null) {
          return request();
        }
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }
}