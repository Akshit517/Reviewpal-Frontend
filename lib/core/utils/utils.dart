
import 'dart:convert';

import 'package:ReviewPal/core/constants/secure_storage_keys.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/data/models/user_model.dart';
import '../../features/auth/domain/entities/user_entity.dart';

class Utils{
  static Future<User> getUser(FlutterSecureStorage flutterSecureStorage) async {
    final user = await flutterSecureStorage.read(key: SecureStorageKeys.user); 
    if (user == null) {
      throw Exception("User not found");
    }
    return UserModel.fromJson(jsonDecode(user));
  }
}