import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/user_repositories.dart';

class LogoutUseCase extends UseCase<void, NoParams> {
  final UserRepositories userRepositories;

  LogoutUseCase({required this.userRepositories});

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await userRepositories.logout();
  }
}
