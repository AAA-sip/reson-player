import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/deps/init.dart';
import 'core/route/app_router.dart';
import 'core/theme/provider/theme_provider.dart';
import 'core/theme/theme_generator.dart';

class ResonApp extends ConsumerWidget {
  const ResonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeConfig = ref.watch(themeControllerProvider);

    final lightTheme = generateTheme(
      brightness: Brightness.light,
      config: themeConfig,
    );

    final darkTheme = generateTheme(
      brightness: Brightness.dark,
      config: themeConfig,
    );

    return MaterialApp.router(
      title: 'Reson',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeConfig.themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      scrollBehavior: BounceScrollBehavior(),
    );
  }
}
