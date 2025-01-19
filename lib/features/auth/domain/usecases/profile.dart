import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repositories.dart';

class FetchProfileUseCase extends UseCase<void, NoParams> {
  final UserRepositories userRepositories;

  FetchProfileUseCase({required this.userRepositories});

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await userRepositories.fetchProfile();
  }
}

class UpdateProfileUseCase extends UseCase<void, ProfileParams> {
  final UserRepositories userRepositories;

  UpdateProfileUseCase({required this.userRepositories});

  @override
  Future<Either<Failure, User>> call(ProfileParams params) async {
    return await userRepositories.updateProfile(
        params.profilePic, params.username);
  }
}

class ProfileParams {
  final String? profilePic;
  final String? username;

  ProfileParams({this.profilePic, this.username});
}
