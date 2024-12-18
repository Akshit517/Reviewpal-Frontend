import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({this.message = 'An unexpected error occurred.'});

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server failure occurred.'});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache failure occurred.'});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Network failure occurred.'});
}

class RefreshTokenInvalidFailure extends Failure {
  const RefreshTokenInvalidFailure({super.message = 'Refresh token is invalid.'});
}

class AlreadyExistsFailure extends Failure {
  const AlreadyExistsFailure({super.message = 'User already exists.'});
}

class GeneralFailure extends Failure {
  const GeneralFailure({super.message = 'General failure occurred.'});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.message = 'Unauthorized failure occurred.'});
}