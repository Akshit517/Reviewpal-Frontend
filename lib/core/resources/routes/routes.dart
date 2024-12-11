import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/presentation/pages/auth_choice_screen.dart';
import '../../../features/auth/presentation/pages/callback_screen.dart';
import '../../../features/auth/presentation/pages/login_screen.dart';
import '../../../features/auth/presentation/pages/signup_screen.dart';

class CustomNavigationHelper {
  static final CustomNavigationHelper _instance =
      CustomNavigationHelper._internal();

  static late final GoRouter router;

  static const String rootAuthPath = '/auth';
  static const String loginPath = '/login';
  static const String signUpPath = '/signUp';
  static const String callbackPath = '/callback';
  static const String errorPath = '/error';
  static const String homePath = '/home';

  static final GlobalKey<NavigatorState> parentNavigatorKey =
      GlobalKey<NavigatorState>();

  factory CustomNavigationHelper() => _instance;

  CustomNavigationHelper._internal();

  static Future<void> initialize({required bool isLoggedIn}) async {
    final AppLinks applinks = AppLinks();
    final routes = _getRoutes();
    //main router
    router = GoRouter(
      navigatorKey: parentNavigatorKey,
      initialLocation: isLoggedIn ? homePath : rootAuthPath,
      routes: routes,
    );
    _handleDeepLinks(applinks);
    await _handleInitialLinks(applinks);
  }

  static List<GoRoute> _getRoutes() {
    return [
      GoRoute(
        path: rootAuthPath,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const AuthChoiceScreen(),
        ),
      ),
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
          final uri = state.extra as Uri?;
          if (uri != null) {
            final String? code = uri.queryParameters['code'];
            final String? stateParam = uri.queryParameters['state'];
            final String redirectUri = Uri(
              scheme: uri.scheme,
              host: uri.host,
              port: uri.port,
              path: uri.path,
            ).toString();

            if (code != null && stateParam != null) {
              return _callbackPage(state, code, stateParam, redirectUri);
            }
          }
          return _errorPage(state.pageKey);
        },
      ),
      GoRoute(
        path: homePath,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const Scaffold(
            body: Center(child: Text('Welcome Home')),
          ),
        ),
      ),
    ];
  }

  static Future<void> _handleInitialLinks(AppLinks applinks) async {
    final initialUri = await applinks.getInitialLink();
    if (initialUri != null) {
      final path = initialUri.path;
      if (path == callbackPath) {
        router.go(callbackPath, extra: initialUri);
      }
    }
  }

  static void _handleDeepLinks(AppLinks applinks) {
    applinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        final path = uri.path;
        if (path == callbackPath) {
          router.go(callbackPath, extra: uri);
        }
      }
    });
  }

  static MaterialPage<dynamic> _callbackPage(
      GoRouterState state, String code, String stateParam, String redirectUri) {
    return MaterialPage(
      key: state.pageKey,
      child: CallbackScreen(
        code: code,
        provider: stateParam,
        redirectUri: redirectUri,
      ),
    );
  }

  static MaterialPage<dynamic> _errorPage(LocalKey key) {
    return MaterialPage(
      key: key,
      child: const Scaffold(
        body: Center(
          child: Text('Error: Missing or invalid parameters',
              style: TextStyle(color: Colors.red)),
        ),
      ),
    );
  }
}
