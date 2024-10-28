import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

String _baseUrl = 'http://127.0.0.1:8000/';

abstract class UserRemoteDataSource {

  Future<UserModel> loginWithEmailPassword(String email, String password);

  Future<UserModel> loginWithOAuth(String provider);

  Future<UserModel> registerWithEmailPassword(String email, String password, String username);

  Future<void> logout(UserModel userToLogout);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> loginWithEmailPassword(String email, String password) async {
    final response = await client.post(
        Uri.parse('${_baseUrl}login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password
        }),
      );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException();
    }
  } 

  @override
  Future<UserModel> loginWithOAuth(String provider) async {
    final response = await client.get(
      Uri.parse('${_baseUrl}signin/$provider/'),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> registerWithEmailPassword(
    String email, 
    String password, 
    String username
  ) async {
    final response = await client.post(
      Uri.parse('${_baseUrl}register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'email': email
      }),
    );

    if (response.statusCode == 201) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> logout(UserModel userToLogout) async {
    final response = await client.post(
      Uri.parse('${_baseUrl}logout/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh_token': userToLogout.refreshToken}),
    );

    if (response.statusCode == 204) {
      return;
    } else {
      throw ServerException();
    }
  }
}