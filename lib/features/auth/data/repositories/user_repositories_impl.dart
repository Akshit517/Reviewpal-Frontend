import 'package:ReviewPal/core/error/exceptions.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/token_entity.dart';
import '../../domain/entities/user_entity.dart';
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
    required this.networkInfo,
  });

  Future<Either<Failure, T>> _checkNetwork<T>(Future<Either<Failure, T>> Function() action) async {
    if (!(await networkInfo.isConnected)) {
      return Left(NetworkFailure()); 
    }
    return await action();
  }

  Future<Either<Failure, User>> _getUser(
    Future<UserModel> Function() getUser,
  ) async {
    return await _checkNetwork(() async {
      try {
        final user = await getUser();
        await localDataSource.cacheUser(user);
        await localDataSource.cacheToken(user.tokenModel);
        return Right(user);
      } on ServerException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
      }
    });
  }

  @override
  Future<Either<Failure, User>> loginWithEmailPassword(
      String email, 
      String password,
  ) async {
    return await _checkNetwork(() async {
      return await _getUser(
        () => remoteDataSource.loginWithEmailPassword(email, password),
      );
    });
  }

  @override
  Future<Either<Failure, User>> loginWithOAuth(String provider) async {
    return await _checkNetwork(() async {
      return await _getUser(
        () => remoteDataSource.loginWithOAuth(provider),
      );
    });
  }

  @override
  Future<Either<Failure, User>> registerWithEmailPassword(
      String email,
      String password,
      String username,
  ) async {
    return await _checkNetwork(() async {
      return await _getUser(
        () => remoteDataSource.registerWithEmailPassword(email, password, username),
      );
    });
  }

  @override
  Future<Either<Failure, void>> logout() async {
    return await _checkNetwork(() async {
      try {
        final token = await localDataSource.getCachedToken(); 
        await remoteDataSource.logout(token);
        await localDataSource.deleteCachedUser();
        await localDataSource.deleteToken();
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
      }
    });
  }

  @override
  Future<Either<Failure, Token>> getNewToken() async {
    return await _checkNetwork(() async {
      try {
        final token = await localDataSource.getCachedToken();
        final newToken = await remoteDataSource.getNewToken(token.refreshToken);
        await localDataSource.cacheToken(newToken);
        return Right(newToken);
      } on ServerException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
      }
    });
  }

  @override
  Future<Either<Failure, bool>> checkTokenValidation(String token) async {
    return await _checkNetwork(() async {
      try {
        return Right(await remoteDataSource.checkTokenValidation(token));
      } on ServerException {
        return Left(ServerFailure());
      }
    });
  }

  @override
  Future<Either<Failure, Token>> getToken() async {
    return await _checkNetwork(() async {
      try {
        final tokens = await localDataSource.getCachedToken();
        return Right(tokens);
      } on ServerException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
      }
    }); 
  }
}