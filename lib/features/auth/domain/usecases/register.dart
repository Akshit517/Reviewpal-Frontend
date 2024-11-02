import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/user_repositories.dart';

class RegisterUseCase implements UseCase<void, RegisterParams> {
  final UserRepositories userRepositories;

  RegisterUseCase(this.userRepositories);

  @override
  Future<Either<Failure, void>> call(RegisterParams params) async {
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
