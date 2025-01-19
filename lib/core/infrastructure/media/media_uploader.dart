import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../../constants/constants.dart';
import '../http/token_manager.dart';
import '../http/token_refresher.dart';

class MediaUploader {
  final TokenManager tokenManager;
  final TokenRefresher tokenRefresher;

  MediaUploader({
    required this.tokenManager,
    required this.tokenRefresher,
  });

  Future<String> uploadMedia({required File file}) async {
    String? token = await tokenManager.accessToken;

    if (token == null || await tokenManager.isTokenExpired()) {
      token = await _refreshTokenIfNeeded();
    }
    final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
    final mimeTypeParts = mimeType.split('/');

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppConstants.baseUrl}upload-media/'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      file.path,
      contentType: MediaType(mimeTypeParts[0], mimeTypeParts[1]),
    ));

    final response = await request.send();

    if (response.statusCode == 201) {
      final responseData = jsonDecode(await response.stream.bytesToString())
          as Map<String, dynamic>;
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
