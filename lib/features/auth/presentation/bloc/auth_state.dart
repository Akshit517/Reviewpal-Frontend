part of 'auth_bloc.dart';

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  final String? email;
  final String? accessToken;
  final String? refreshToken;

  const AuthSuccess(this.message,
      {this.email, this.accessToken, this.refreshToken});
}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure(this.error);
}
