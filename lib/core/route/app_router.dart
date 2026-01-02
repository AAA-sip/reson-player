import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screems.dart';

enum AppRoutes {
  home('/home', HomeScreen()),
  search('/search', SearchScreen()),
  settings('/settings', SettingsScreen()),
  player('/player', PlayerScreen());

  final String path;
  final Widget screen;

  const AppRoutes(this.path, this.screen);

  String get name => toString().split('.').last;
}

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.home.path,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.home.path,
      builder: (_, _) => AppRoutes.home.screen,
    ),
    GoRoute(
      path: AppRoutes.search.path,
      builder: (_, _) => AppRoutes.search.screen,
    ),
    GoRoute(
      path: AppRoutes.settings.path,
      builder: (_, _) => AppRoutes.settings.screen,
    ),
    GoRoute(
      path: AppRoutes.player.path,
      builder: (_, _) => AppRoutes.player.screen,
    ),
  ],
);

/// Mock screen for AppRoutes
class MockScreen extends StatelessWidget {
  const MockScreen({super.key});

  @override
  Widget build(_) => const Scaffold(body: Center(child: Text('Mock Screen')));
}
