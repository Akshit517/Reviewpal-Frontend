import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class UserLocalDataSource {
    Future<UserModel> getCachedUser();

    Future<void> cacheUser(UserModel userToCache);

    Future<void> deleteCachedUser();
}

// ignore: constant_identifier_names
const CACHED_USER = 'CACHED_USER';

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
            key: CACHED_USER, 
            value: jsonEncode(userToCache.toJson())
        );
      } on Exception {
        throw CacheException();
      }
    }

    @override
    Future<void> deleteCachedUser() async {
      try {
        await secureStorage.delete(
            key: CACHED_USER
        );
      } on Exception {
          throw CacheException();
      }
    }
}