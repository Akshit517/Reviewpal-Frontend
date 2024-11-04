import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/get_token.dart';
import '../../domain/usecases/register.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final GetTokenUseCase getTokenUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.getTokenUseCase,
  }) : super(AuthInitial()) {
    on<AuthSignUp>(_onSignUp);
    on<AuthLogin>(_onLogin);
    on<GetTokens>(_onGetTokens);
  }

  Future<void> _onSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await registerUseCase(RegisterParams(
      username: event.username,
      email: event.email,
      password: event.password,
    ));
    result.fold(
      (failure) => emit(AuthFailure(_mapFailureToMessage(failure))),
      (user) =>
          emit(AuthSuccess("Sign-up successful", username: user.username)),
    );
  }

  Future<void> _onLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUseCase(LoginParams.emailPassword(
      email: event.email,
      password: event.password,
    ));
    result.fold(
      (failure) => emit(AuthFailure(_mapFailureToMessage(failure))),
      (user) => emit(AuthSuccess("Login successful", username: user.username)),
    );
  }

  Future<void> _onGetTokens(GetTokens event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await getTokenUseCase(NoParams());
    result.fold(
      (failure) => emit(AuthFailure(_mapFailureToMessage(failure))),
      (token) => emit(AuthSuccess("Token retrieved successfully",
          accessToken: token.accessToken, refreshToken: token.refreshToken)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) return 'Server failure.';
    if (failure is CacheFailure) return 'Cache failure.';
    if (failure is NetworkFailure) return 'Network failure.';
    if (failure is RefreshTokenInvalidFailure) return 'Invalid refresh token.';
    return 'Unexpected error.';
  }
}
