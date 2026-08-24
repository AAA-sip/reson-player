import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:go_router/go_router.dart';

import 'routes.dart';
import 'screens.dart';

final GoRouter cupertinoRouter = GoRouter(
  initialLocation: CupertinoRoutes.home.path,
  routes: [
    GoRoute(
      path: CupertinoRoutes.home.path,
      pageBuilder: (_, state) => CupertinoPage(key: state.pageKey, child: const CupertinoHomeScreen()),
    ),
    GoRoute(
      path: CupertinoRoutes.settings.path,
      pageBuilder: (_, state) => CupertinoPage(key: state.pageKey, child: const CupertinoSettingsScreen()),
    ),
  ],
);
