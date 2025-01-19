part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class AuthSignUp extends AuthEvent {
  final String username;
  final String email;
  final String password;

  const AuthSignUp(
      {required this.username, required this.email, required this.password});
}

class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  const AuthLogin({required this.email, required this.password});
}

class AuthLoginOAuth extends AuthEvent {
  final String provider;
  final String code;
  final String redirectUri;

  const AuthLoginOAuth({
    required this.provider,
    required this.code,
    required this.redirectUri,
  });
}

class GetTokens extends AuthEvent {}

class AuthLogout extends AuthEvent {}
