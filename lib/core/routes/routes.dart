import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/signup_screen.dart';

GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: <RouteBase>[
    //GoRoute(
    //    path: '/',
    //  builder: (context, state) => const HomeScreen(),
    //  ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',  
      builder: (context, state) => const SignUpScreen(),
    ),
  ],
);