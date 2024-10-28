import '../../domain/entities/user_entities.dart';

class UserModel extends User {
  final String accessToken;
  final String refreshToken;

  UserModel({
    required int id,
    required String username,
    required String email,
    required String profilePic,
    required String authType,
    required this.accessToken,
    required this.refreshToken,
  }) : super(
          id: id,
          username: username,
          email: email,
          profilePic: profilePic,
          authType: authType
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user']['id'],
      username: json['user']['username'],
      email: json['user']['email'],
      profilePic: json['user']['profilePic'],
      authType: json['user']['authType'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
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
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
