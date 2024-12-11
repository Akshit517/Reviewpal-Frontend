import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/token_entity.dart';
import '../repositories/user_repositories.dart';

class GetTokenUseCase extends UseCase<Token, NoParams> {
  final UserRepositories userRepositories;

  GetTokenUseCase({required this.userRepositories});

  @override
  Future<Either<Failure, Token>> call(NoParams params) async {
    final cachedTokenOrFailure = await userRepositories.getToken();

    return cachedTokenOrFailure.fold(
      (failure) => Left(failure),
      (cachedToken) async {
        final accessTokenValidation = await userRepositories
            .checkTokenValidation(cachedToken.accessToken);

        return await accessTokenValidation.fold(
          (failure) => Left(failure),
          (isAccessTokenValid) async {
            if (isAccessTokenValid) {
              return Right(cachedToken);
            } else {
              final refreshTokenValidation = await userRepositories
                  .checkTokenValidation(cachedToken.refreshToken);

              return await refreshTokenValidation.fold(
                (failure) => Left(failure),
                (isRefreshTokenValid) async {
                  if (!isRefreshTokenValid) {
                    return const Left(RefreshTokenInvalidFailure());
                  }

                  final newTokensOrFailure =
                      await userRepositories.getNewToken();

                  return newTokensOrFailure;
                },
              );
            }
          },
        );
      },
    );
  }
}
