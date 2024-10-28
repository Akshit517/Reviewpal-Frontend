import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/user_entities.dart';
import '../repositories/user_repositories.dart';

class LoginWithOauthUseCase implements UseCase<User, LoginWithOauthParams>{
    final UserRepositories userRepositories;
    
    LoginWithOauthUseCase({required this.userRepositories});

    @override
    Future<Either<Failure, User>> call(LoginWithOauthParams params) async {
        return await userRepositories.loginWithOAuth(params.provider);
    }
}


class LoginWithOauthParams extends Equatable {
    final String provider;

    const LoginWithOauthParams({required this.provider});

    @override
    List<Object> get props => [provider];
}