import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/presentation/pages/callback_screen.dart';
import '../../../features/auth/presentation/pages/login_screen.dart';
import '../../../features/auth/presentation/pages/signup_screen.dart';

class CustomNavigationHelper {
  static final CustomNavigationHelper _instance =
      CustomNavigationHelper._internal();

  static late final GoRouter router;

  static const String loginPath = '/login';
  static const String signUpPath = '/signUp';
  static const String callbackPath = '/callback';

  static final GlobalKey<NavigatorState> parentNavigatorKey =
      GlobalKey<NavigatorState>();

  factory CustomNavigationHelper() => _instance;

  CustomNavigationHelper._internal();

  static Future<void> initialize() async {
    final AppLinks _applinks = AppLinks();
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
      GoRoute(
          path: callbackPath,
          pageBuilder: (context, state) {
            final uri = state.extra as Uri;
            final String queryCode = uri.queryParameters['code']!;
            final String queryState = uri.queryParameters['state']!;
            return MaterialPage(
              key: state.pageKey,
              child: const CallbackScreen(),
            );
          }),
    ];
    router = GoRouter(
      navigatorKey: parentNavigatorKey,
      initialLocation: signUpPath,
      routes: routes,
    );
    _applinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        final path = uri.path;
        if (path == callbackPath) {
          router.go(callbackPath, extra: uri);
        }
      }
    });

    final initialUri = await _applinks.getInitialLink();
    if (initialUri != null) {
      final path = initialUri.path;
      if (path == callbackPath) {
        router.go(callbackPath, extra: initialUri);
      }
    }
  }
}
