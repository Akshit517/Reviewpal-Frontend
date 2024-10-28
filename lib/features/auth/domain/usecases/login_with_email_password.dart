import 'package:ReviewPal/core/usecases/usecases.dart';
import 'package:ReviewPal/features/auth/domain/repositories/user_repositories.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entities.dart';

class LoginWithEmailPassword implements UseCase<User,LoginParams>{
  final UserRepositories userRepositories;

  LoginWithEmailPassword(this.userRepositories);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await userRepositories.loginWithEmailPassword(params.email, params.password); 
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}