import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/error/exceptions.dart';
import '../models/token_model.dart';
import '../repositories/user_model.dart';

abstract class UserLocalDataSource {
  Future<UserModel> getCachedUser();
  Future<void> cacheUser(UserModel userToCache);
  Future<void> deleteCachedUser();

  Future<void> cacheToken(TokenModel tokensToCache);
  Future<void> deleteToken();
  Future<TokenModel> getCachedToken();
}

// ignore: constant_identifier_names
const CACHED_USER = 'CACHED_USER';
const ACCESS_TOKEN = 'ACCESS_TOKEN';
const REFRESH_TOKEN = 'REFRESH_TOKEN';

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final FlutterSecureStorage secureStorage;

  UserLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<UserModel> getCachedUser() async {
    final user = await secureStorage.read(key: CACHED_USER);
    if (user == null) {
      throw CacheException();
    }
    return UserModel.fromJson(jsonDecode(user));
  }

  @override
  Future<void> cacheUser(UserModel userToCache) async {
    try {
      await secureStorage.write(
          key: CACHED_USER, value: jsonEncode(userToCache.toJson()));    
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheToken(TokenModel tokensToCache) async {
    try {
      await secureStorage.write(
          key: ACCESS_TOKEN, value: tokensToCache.accessToken);
      await secureStorage.write(
          key: REFRESH_TOKEN, value: tokensToCache.refreshToken);
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteCachedUser() async {
    try {
      await secureStorage.delete(key: CACHED_USER);
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      await secureStorage.delete(key: ACCESS_TOKEN);
      await secureStorage.delete(key: REFRESH_TOKEN);
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<TokenModel> getCachedToken() async {
    String? refreshToken = await secureStorage.read(key: REFRESH_TOKEN);
    String? accessToken = await secureStorage.read(key: ACCESS_TOKEN);

    if (refreshToken == null || accessToken == null) {
      throw CacheException();
    }

    return TokenModel(accessToken: accessToken, refreshToken: refreshToken);
  }
}
