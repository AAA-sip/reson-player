import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens.dart';
import 'shell/screen_with_player.dart';

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.home.path,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (_, _, child) => ScreenWithPlayer(child: child),
      routes: [
        GoRoute(path: AppRoutes.home.path, builder: (_, _) => const HomeScreen()),
        GoRoute(path: AppRoutes.search.path, builder: (_, _) => const SearchScreen()),
        GoRoute(path: AppRoutes.settings.path, builder: (_, _) => const SettingsScreen()),
        GoRoute(path: AppRoutes.theme.path, builder: (_, _) => const PlayerScreen()),
      ],
    ),

    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.player.path,
      builder: (_, _) => const PlayerScreen(),
    ),
  ],
);

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

enum AppRoutes {
  home('/home'),
  search('/search'),
  settings('/settings'),
  theme('/theme'),
  player('/player');

  final String path;

  const AppRoutes(this.path);

  String get name => toString().split('.').last;
}

/// Mock screen for AppRoutes
class MockScreen extends StatelessWidget {
  const MockScreen({super.key});

  @override
  Widget build(_) => const Scaffold(body: Center(child: Text('Mock Screen')));
}
