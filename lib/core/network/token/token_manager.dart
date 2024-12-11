import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../constants/secure_storage_keys.dart';

class TokenManager {
  final FlutterSecureStorage secureStorage;

  TokenManager({required this.secureStorage});

  Future<String?> get accessToken async => await secureStorage.read(key: SecureStorageKeys.accessToken);
  Future<String?> get refreshToken async => await secureStorage.read(key: SecureStorageKeys.refreshToken);

  Future<void> setTokens(String accessToken, String refreshToken) async {
    await secureStorage.write(key: SecureStorageKeys.accessToken, value: accessToken);
    await secureStorage.write(key: SecureStorageKeys.refreshToken, value: refreshToken);
  }

  Future<void> clearTokens() async {
    await secureStorage.delete(key: SecureStorageKeys.accessToken);
    await secureStorage.delete(key: SecureStorageKeys.refreshToken);
  }
}
