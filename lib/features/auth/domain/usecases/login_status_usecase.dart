import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/user_repositories.dart';

class LoginStatusUseCase extends UseCase<bool ,NoParams> {
  final UserRepositories userRepositories;

  LoginStatusUseCase({required this.userRepositories});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async { 
    return await userRepositories.checkLoginStatus();
  }
}