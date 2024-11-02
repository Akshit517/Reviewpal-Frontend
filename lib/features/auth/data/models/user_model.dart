import './token_model.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends User {
  final TokenModel tokenModel;

  UserModel(
      {required super.id,
      required super.username,
      required super.email,
      required super.profilePic,
      required super.authType,
      required this.tokenModel});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['user']['id'],
        username: json['user']['username'],
        email: json['user']['email'],
        profilePic: json['user']['profilePic'],
        authType: json['user']['authType'],
        tokenModel: TokenModel.fromJson(json));
  }

  Map<String, dynamic> toJson() {
    return {
      'user': {
        'id': id,
        'username': username,
        'email': email,
        'profilePic': profilePic,
        'authType': authType,
      },
      ...tokenModel.toJson()
    };
  }
}
