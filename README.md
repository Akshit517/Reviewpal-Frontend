# asgrev

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

StatefulShellRoute.indexedStack(
        parentNavigatorKey: parentNavigatorKey,
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: homePath,
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: const HomePage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: searchPath,
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: const SearchPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: settingsPath,
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: const SettingsPage(),
                ),
              ),
            ],
          ),
        ],
        pageBuilder: (context, state, navigationShell) => MaterialPage(
          key: state.pageKey,
          child: BottomNavigationPage(child: navigationShell),
        ),
      ),
    ];

    router = GoRouter(
      navigatorKey: parentNavigatorKey,
      initialLocation: signUpPath,
      routes: routes,
    );
  }
  static const String detailPath = '/detail';
  static const String homePath = '/home';
  static const String searchPath = '/search';
  static const String settingsPath = '/settings';