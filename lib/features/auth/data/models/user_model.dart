import 'token_model.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends User {
  final TokenModel? tokenModel;

  UserModel(
      {required super.id,
      required super.username,
      required super.email,
      required super.profilePic,
      required super.authType,
      this.tokenModel});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userData = json['user'] ?? json;
    return UserModel(
      id: userData['id'],
      username: userData['username'],
      email: userData['email'],
      profilePic: userData['profile_pic'],
      authType: userData['auth_type'],
      tokenModel: json.containsKey('token') ? TokenModel.fromJson(json) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': {
        'id': id,
        'username': username,
        'email': email,
        'profile_pic': profilePic,
        'auth_type': authType,
      },
      ...tokenModel!.toJson()
    };
  }
}
