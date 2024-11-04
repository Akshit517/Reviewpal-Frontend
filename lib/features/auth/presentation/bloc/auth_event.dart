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

class GetTokens extends AuthEvent {}