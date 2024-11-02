import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/presentation/pages/login_screen.dart';
import '../../../features/auth/presentation/pages/signup_screen.dart';

class CustomNavigationHelper {
  static final CustomNavigationHelper _instance =
      CustomNavigationHelper._internal();

  static late final GoRouter router;

  static const String loginPath = '/login';
  static const String signUpPath = '/signUp';

  static final GlobalKey<NavigatorState> parentNavigatorKey =
      GlobalKey<NavigatorState>();

  factory CustomNavigationHelper() => _instance;

  CustomNavigationHelper._internal();

  static void initialize() {
    final routes = [
      GoRoute(
        path: loginPath,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: signUpPath,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const SignUpScreen(),
        ),
      ),
    ];

    router = GoRouter(
      navigatorKey: parentNavigatorKey,
      initialLocation: loginPath,
      routes: routes,
    );
  }
}
