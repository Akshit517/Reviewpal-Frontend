import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repositories.dart';

class FetchUser implements UseCase<User, LoginParams> {
  final UserRepositories userRepositories;

  FetchUser(this.userRepositories);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    if (params.isOAuth) {
      return await userRepositories.loginWithOAuth(params.provider!);
    }
    return await userRepositories.loginWithEmailPassword(
        params.email!, params.password!);
  }
}

class LoginParams extends Equatable {
  final String? email;
  final String? password;
  final String? provider;
  final bool isOAuth;

  const LoginParams(
      {this.email, this.password, this.provider, this.isOAuth = false});

  @override
  List<Object?> get props => [email, password, provider, isOAuth];

  factory LoginParams.emailPassword({
    required String email,
    required String password,
  }) {
    return LoginParams(email: email, password: password);
  }

  factory LoginParams.oauth({required String provider}) {
    return LoginParams(provider: provider, isOAuth: true);
  }
}
