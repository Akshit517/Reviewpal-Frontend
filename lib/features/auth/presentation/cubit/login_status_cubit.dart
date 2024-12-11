import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecases.dart';
import '../../domain/usecases/login_status_usecase.dart';

part 'login_status_state.dart';

class LoginStatusCubit extends Cubit<LoginStatusState> {
  final LoginStatusUseCase loginStatusUseCase;

  LoginStatusCubit({required this.loginStatusUseCase}) : super(LoginStatusInitial());

  Future<void> checkLoginStatus() async {
    emit(LoginStatusInitial());
    final result = await loginStatusUseCase.call(NoParams());
    result.fold(
      (failure) => emit(FailedLogin()), 
      (isLogin) {
        if (isLogin) {
          emit(SuccessfulLogin());
        } else {
          emit(FailedLogin());
        }
      });
  }
}
