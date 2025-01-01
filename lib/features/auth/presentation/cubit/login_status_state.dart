part of 'login_status_cubit.dart';

sealed class LoginStatusState extends Equatable {
  const LoginStatusState();

  @override
  List<Object> get props => [];
}

final class LoginStatusInitial extends LoginStatusState {}

final class SuccessfulLogin extends LoginStatusState {}

final class FailedLogin extends LoginStatusState {}