import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entities.dart';

abstract class UserRepositories {
  Future<Either<Failure, User>> loginWithEmailPassword(String email, String password);

  Future<Either<Failure, User>> loginWithOAuth(String provider);

  Future<Either<Failure, User>> registerWithEmailPassword(String email, String password, String username);

  Future<Either<Failure, void>> logout();
}