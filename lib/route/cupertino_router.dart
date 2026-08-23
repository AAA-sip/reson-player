import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:go_router/go_router.dart';

import '../ui/cupertino/home_screen.dart';
import '../ui/cupertino/settings_screen.dart';

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

enum CupertinoRoutes {
  home('/home'),
  settings('/settings');

  final String path;

  const CupertinoRoutes(this.path);

  String get name => toString().split('.').last;
}
