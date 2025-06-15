import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'asgrev_app.dart';
import 'features/injection.dart';
import 'features/bloc_observer.dart';
import 'features/injection.dart' as di;
import 'core/resources/routes/routes.dart';
import 'features/auth/presentation/cubit/login_status_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  final LoginStatusCubit loginStatusCubit = sl<LoginStatusCubit>();

  final loginStatusFuture = loginStatusCubit.stream
      .firstWhere((state) => state is SuccessfulLogin || state is FailedLogin);

  await loginStatusCubit.checkLoginStatus();

  final loginStatus = await loginStatusFuture;

  final isLoggedIn = loginStatus is SuccessfulLogin;

  await CustomNavigationHelper.initialize(isLoggedIn: isLoggedIn);

  Bloc.observer = AppBlocObserver();

  runApp(
    const AsgRevApp(),
  );
}
