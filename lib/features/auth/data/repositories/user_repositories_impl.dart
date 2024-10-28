import 'package:ReviewPal/core/error/exceptions.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user_entities.dart';
import '../../domain/repositories/user_repositories.dart';
import '../datasources/user_local_data_source.dart';
import '../datasources/user_remote_data_source.dart';
import '../models/user_model.dart';

class UserRepositoriesImpl implements UserRepositories {
    final UserLocalDataSource localDataSource;
    final UserRemoteDataSource remoteDataSource;
    final NetworkInfo networkInfo;

    UserRepositoriesImpl({
        required this.localDataSource,
        required this.remoteDataSource,
        required this.networkInfo
    });

    Future<Either<Failure, User>> _getUser (Future<UserModel> Function() getUser) async {
      if (!(await networkInfo.isConnected)) {
        return Left(NetworkFailure()); 
      }
      try {
        final user = await getUser();
        await localDataSource.cacheUser(user);
        return Right(user);
      } on ServerException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
    
    @override
    Future<Either<Failure, User>> loginWithEmailPassword(
        String email, 
        String password
    ) async {
        return _getUser(() => 
          remoteDataSource.loginWithEmailPassword(email, password));
    }

    @override
    Future<Either<Failure, User>> loginWithOAuth(
        String provider
    ) async {
        return _getUser(() => 
          remoteDataSource.loginWithOAuth(provider));
    }

    @override
    Future<Either<Failure, User>> registerWithEmailPassword(
        String email,
        String password,
        String username
    ) async {
        return _getUser(() => 
          remoteDataSource.registerWithEmailPassword(email, password, username));
    }

    @override
    Future<Either<Failure, void>> logout() async {
        final user = await localDataSource.getCachedUser();
        try {
            await remoteDataSource.logout(user);
            await localDataSource.deleteCachedUser();
            return const Right(null);
        } on ServerException {
            return Left(ServerFailure());
        } on CacheException {
            return Left(CacheFailure());
        }
    }
}