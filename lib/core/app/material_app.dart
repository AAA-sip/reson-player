import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../route/material_router.dart';
import '../../theme/provider/theme_provider.dart';
import '../../theme/theme_generator.dart';

class MaterialResonApp extends ConsumerWidget {
  const MaterialResonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeConfig = ref.watch(themeControllerProvider);

    return MaterialApp.router(
      title: 'Reson',
      theme: generateTheme(brightness: Brightness.light, config: themeConfig),
      darkTheme: generateTheme(brightness: Brightness.dark, config: themeConfig),
      themeMode: themeConfig.themeMode,
      routerConfig: materialRouter,
      locale: context.locale,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      debugShowCheckedModeBanner: false,
    );
  }
}
