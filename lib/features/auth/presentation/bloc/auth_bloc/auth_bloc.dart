import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecases.dart';
import '../../../domain/usecases/login.dart';
import '../../../domain/usecases/get_token.dart';
import '../../../domain/usecases/logout.dart';
import '../../../domain/usecases/register.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final GetTokenUseCase getTokenUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.getTokenUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial()) {
    on<AuthSignUp>(_onSignUp);
    on<AuthLogin>(_onLogin);
    on<AuthLoginOAuth>(_onLoginOAuth);
    on<GetTokens>(_onGetTokens);
    on<AuthLogout>(_onLogout);
  }

  Future<void> _onSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await registerUseCase(RegisterParams(
      username: event.username,
      email: event.email,
      password: event.password,
    ));
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess("Sign-up successful", email: user.email)),
    );
  }

  Future<void> _onLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUseCase(LoginParams.emailPassword(
      email: event.email,
      password: event.password,
    ));
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess("Login successful", email: user.email)),
    );
  }

  Future<void> _onLoginOAuth(
      AuthLoginOAuth event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUseCase(LoginParams.oauth(
      code: event.code,
      provider: event.provider,
      redirectUri: event.redirectUri,
    ));
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess("Login successful", email: user.email)),
    );
  }

  Future<void> _onGetTokens(GetTokens event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await getTokenUseCase(NoParams());
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (token) => emit(AuthSuccess("Token retrieved successfully",
          accessToken: token.accessToken, refreshToken: token.refreshToken)),
    );
  }

  Future<void> _onLogout(AuthLogout event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await logoutUseCase(NoParams());
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(UnAuthenticated()),
    );
  }
}
