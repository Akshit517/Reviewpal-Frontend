import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repositories.dart';

class RegisterUseCase implements UseCase<User, RegisterParams> {
  final UserRepositories userRepositories;

  RegisterUseCase({required this.userRepositories});

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await userRepositories.registerWithEmailPassword(
        params.email, params.password, params.username);
  }
}

class RegisterParams extends Equatable {
  final String username;
  final String email;
  final String password;

  const RegisterParams({
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [username, email, password];
}
