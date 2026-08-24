import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'routes.dart';
import 'screens.dart';
import 'shell/screen_with_player.dart';

final GoRouter materialRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: MaterialRoutes.home.path,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (_, _, child) => ScreenWithPlayer(child: child),
      routes: [
        GoRoute(path: MaterialRoutes.home.path, builder: (_, _) => const HomeScreen()),
        GoRoute(path: MaterialRoutes.search.path, builder: (_, _) => const SearchScreen()),
        GoRoute(path: MaterialRoutes.settings.path, builder: (_, _) => const SettingsScreen()),
        GoRoute(path: MaterialRoutes.theme.path, builder: (_, _) => const ThemeScreen()),
      ],
    ),

    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: MaterialRoutes.player.path,
      builder: (_, _) => const PlayerScreen(),
    ),
  ],
);

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
