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
        GoRoute(path: AppRoutes.home.path, builder: (_, _) => AppRoutes.home.screen),
        GoRoute(path: AppRoutes.search.path, builder: (_, _) => AppRoutes.search.screen),
        GoRoute(path: AppRoutes.settings.path, builder: (_, _) => AppRoutes.settings.screen),
        GoRoute(path: AppRoutes.theme.path, builder: (_, _) => AppRoutes.theme.screen),
      ],
    ),

    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.player.path,
      builder: (_, _) => AppRoutes.player.screen,
    ),
  ],
);

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

enum AppRoutes {
  home('/home', HomeScreen()),
  search('/search', SearchScreen()),
  settings('/settings', SettingsScreen()),
  theme('/theme', ThemeScreen()),
  player('/player', PlayerScreen());

  final String path;
  final Widget screen;

  const AppRoutes(this.path, this.screen);

  String get name => toString().split('.').last;
}

/// Mock screen for AppRoutes
class MockScreen extends StatelessWidget {
  const MockScreen({super.key});

  @override
  Widget build(_) => const Scaffold(body: Center(child: Text('Mock Screen')));
}
