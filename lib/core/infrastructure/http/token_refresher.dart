import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../constants/constants.dart';
import 'token_manager.dart';

class TokenRefresher {
  final TokenManager tokenManager;
  final http.Client client;

  TokenRefresher({ required this.tokenManager, required this.client});

  Future<void> refreshToken() async {
    final refreshToken = await tokenManager.refreshToken;
    if (refreshToken == null) {
      throw Exception("No refresh token available");
    }

    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}api/token/refresh/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'refresh_token': refreshToken}),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final newAccessToken = decoded['access_token'];
      final newRefreshToken = decoded['refresh_token'];

      await tokenManager.setTokens(newAccessToken, newRefreshToken);
    } else {
      throw Exception("Failed to refresh token");
    }
  }
}
