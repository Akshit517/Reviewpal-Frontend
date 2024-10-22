import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/token_entity.dart';
import '../entities/user_entity.dart';

abstract class UserRepositories {
  Future<Either<Failure, User>> loginWithEmailPassword(
      String email, String password);

  Future<Either<Failure, User>> loginWithOAuth(
      String provider, String code, String redirectUri);

  Future<Either<Failure, User>> registerWithEmailPassword(
      String email, String password, String username);

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, Token>> getToken();
  Future<Either<Failure, bool>> checkTokenValidation(String token);
  Future<Either<Failure, Token>> getNewToken();
}
