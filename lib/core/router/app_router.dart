import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/file_types.dart';
import '../../features/files/files_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/shell/main_shell.dart';
import '../../features/tools/tools_screen.dart';

/// Root navigator key shared across the application and router.
final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

/// Provider for application routing configured with GoRouter and StatefulShellRoute.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tools',
                name: 'tools',
                builder: (context, state) => const ToolsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                name: 'settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/files',
        name: 'files',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final categoryParam = state.uri.queryParameters['category'];
          FileCategory? category;
          if (categoryParam != null &&
              categoryParam.isNotEmpty &&
              categoryParam.toLowerCase() != 'all') {
            category = FileCategory.values
                .where((c) => c.name == categoryParam.toLowerCase())
                .firstOrNull;
          }
          return FilesScreen(category: category);
        },
      ),
    ],
  );
});
