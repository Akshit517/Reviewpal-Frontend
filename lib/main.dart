import 'package:ReviewPal/features/auth/presentation/cubit/login_status_cubit.dart';
import 'package:ReviewPal/features/injection.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

import 'asgrev_app.dart';
import 'core/resources/routes/routes.dart';
import 'features/injection.dart' as di;

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

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const AsgRevApp(),
    ),
  );
}
