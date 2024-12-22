import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../token/token_manager.dart';
import '../token/token_refresher.dart';

class MediaUploader {
  final TokenManager tokenManager;
  final TokenRefresher tokenRefresher;

  MediaUploader({
    required this.tokenManager,
    required this.tokenRefresher,
  });

  Future<String> uploadMedia({required File image}) async {
    String? token = await tokenManager.accessToken;

    if (token == null || await tokenManager.isTokenExpired()) {
      token = await _refreshTokenIfNeeded();
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppConstants.baseUrl}upload-media/'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    final response = await request.send();

    if (response.statusCode == 201) {
      final responseData =
          jsonDecode(await response.stream.bytesToString()) as Map<String, dynamic>;
      return responseData['url']; 
    } else {
      throw Exception('Failed to upload media: ${response.statusCode}');
    }
  }

  Future<String?> _refreshTokenIfNeeded() async {
    try {
      await tokenRefresher.refreshToken();
      return tokenManager.accessToken;
    } catch (e) {
      throw Exception('Failed to refresh token: $e');
    }
  }
}
