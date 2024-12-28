import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/presentation/pages/auth_choice_screen.dart';
import '../../../features/auth/presentation/pages/callback_screen.dart';
import '../../../features/auth/presentation/pages/login_screen.dart';
import '../../../features/auth/presentation/pages/signup_screen.dart';
import '../../../features/workspaces/domain/entities/category_entity.dart';
import '../../../features/workspaces/domain/entities/channel_entity.dart';
import '../../../features/workspaces/domain/entities/workspace_entity.dart';
import '../../../features/workspaces/presentation/pages/screens/add_update_assignment.dart';
import '../../../features/workspaces/presentation/pages/screens/assignment_screen.dart';
import '../../../features/workspaces/presentation/pages/screens/channel_member_screen.dart';
import '../../../features/workspaces/presentation/pages/screens/doubt_screen.dart';
import '../../../features/workspaces/presentation/pages/screens/home_screen.dart';
import '../../../features/workspaces/presentation/pages/screens/submissions_by_user.dart';
import '../../../features/workspaces/presentation/pages/screens/workspace_member.dart';
import '../../../features/workspaces/presentation/pages/screens/your_submissions_screen.dart';
import '../../widgets/bottom_navigation_bar/scaffold_with_nested_navigation.dart';

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
  static const String notificationPath = '/notification';
  static const String profilePath = '/profile';
  static const String addAssignmentScreenPath = '/addAssignmentScreen';
  static const String workspaceMembersPath = '/workspaceMembers';
  static const String channelMembersPath = '/channelMembers';
  static const String assignmentPath ='/assignment';
  static const String doubtPath ='/doubt';
  static const String submissionsPath ='/submissions';
  static const String submissionsByUsersPath ='/submissionsByUser';
  
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

  static List<RouteBase> _getRoutes() {
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
        path: addAssignmentScreenPath,
        pageBuilder: (context, state) {
          Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
          return CustomTransitionPage(
            key: state.pageKey,
            child: AddUpdateAssignmentWidget(
              workspace: extra['workspace'] as Workspace,
              category: extra['category'] as Category,
              channel: extra['channel'] as Channel?,
              forUpdateAssignment: extra['forUpdateAssignment'] as bool,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: workspaceMembersPath,
        pageBuilder: (context, state) {
          Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
          return CustomTransitionPage(
            key: state.pageKey,
            child: WorkspaceMemberWidget(
              workspace: extra['workspace'] as Workspace,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: assignmentPath,
        pageBuilder: (context, state) {
          Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
          return CustomTransitionPage(
            key: state.pageKey,
            child: AssignmentScreen(
              workspace: extra['workspace'] as Workspace,
              category: extra['category'] as Category,
              channel: extra['channel'] as Channel,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        },
      ),
       GoRoute(
        path: channelMembersPath,
        pageBuilder: (context, state) {
          Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
          return CustomTransitionPage(
            key: state.pageKey,
            child: ChannelMemberWidget(
              workspace: extra['workspace'] as Workspace,
              category: extra['category'] as Category,
              channel: extra['channel'] as Channel,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: submissionsPath,
        pageBuilder: (context, state) {
          Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
          return CustomTransitionPage(
            key: state.pageKey,
            child: YourSubmissionsScreen(
              workspace: extra['workspace'] as Workspace,
              category: extra['category'] as Category,
              channel: extra['channel'] as Channel,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        },
      ),
       GoRoute(
        path: submissionsByUsersPath,
        pageBuilder: (context, state) {
          Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
          return CustomTransitionPage(
            key: state.pageKey,
            child: SubmissionsByUserPage(
              workspace: extra['workspace'] as Workspace,
              category: extra['category'] as Category,
              channel: extra['channel'] as Channel,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: doubtPath,
        pageBuilder: (context, state) {
          Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
          return CustomTransitionPage(
            key: state.pageKey,
            child: DoubtScreen(
              workspace: extra['workspace'] as Workspace,
              category: extra['category'] as Category,
              channel: extra['channel'] as Channel,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNestedNavigation(
            navigationShell: navigationShell,
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: homePath,
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: const HomeScreen()
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: notificationPath,
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: const Scaffold(
                    body: Center(child: Text('Notifications'),),),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: profilePath,
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: const Scaffold(
                    body: Center(child: Text('Profile'),),),
                ),
              ),
            ],
          ),
        ])
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
