import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/constants/secure_storage_keys.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/token/token_manager.dart';
import '../models/token_model.dart';
import '../models/user_model.dart';

abstract class UserLocalDataSource {
  Future<UserModel> getCachedUser();
  Future<void> cacheUser(UserModel userToCache);
  Future<void> deleteCachedUser();

  Future<void> cacheToken(TokenModel tokensToCache);
  Future<void> deleteToken();
  Future<TokenModel> getCachedToken();
}
class UserLocalDataSourceImpl implements UserLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final TokenManager tokenManager;

  UserLocalDataSourceImpl({required this.secureStorage, required this.tokenManager});

  @override
  Future<UserModel> getCachedUser() async {
    final user = await secureStorage.read(key: SecureStorageKeys.user);
    if (user == null) {
      throw CacheException();
    }
    return UserModel.fromJson(jsonDecode(user));
  }

  @override
  Future<void> cacheUser(UserModel userToCache) async {
    try {
      await secureStorage.write(
          key: SecureStorageKeys.user, value: jsonEncode(userToCache.toJson()));    
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheToken(TokenModel tokensToCache) async {
    try {
      await tokenManager.setTokens(tokensToCache.accessToken, tokensToCache.refreshToken);
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteCachedUser() async {
    try {
      await secureStorage.delete(key: SecureStorageKeys.user);
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      await tokenManager.clearTokens();
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<TokenModel> getCachedToken() async {
    String? refreshToken = await tokenManager.refreshToken;
    String? accessToken = await tokenManager.accessToken;

    if (refreshToken == null || accessToken == null) {
      throw CacheException();
    }

    return TokenModel(accessToken: accessToken, refreshToken: refreshToken);
  }
}
