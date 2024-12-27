
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/data/models/user_model.dart';
import '../../features/auth/domain/entities/user_entity.dart';
import '../constants/secure_storage_keys.dart';
import '../resources/routes/routes.dart';
import 'enums.dart';

class Utils{
  static Future<User> getUser(FlutterSecureStorage flutterSecureStorage) async {
    final user = await flutterSecureStorage.read(key: SecureStorageKeys.user); 
    if (user == null) {
      throw Exception("User not found");
    }
    return UserModel.fromJson(jsonDecode(user));
  }
  
  static String getPathFromDisplayScreen(DisplayScreen displayScreen){
    switch (displayScreen) {
      case DisplayScreen.assignment:
        return CustomNavigationHelper.assignmentPath;
      case DisplayScreen.doubts:
        return CustomNavigationHelper.doubtPath;
      default:
        return CustomNavigationHelper.homePath;
    }
  }
}