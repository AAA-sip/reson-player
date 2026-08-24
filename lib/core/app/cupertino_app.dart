import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../route/cupertino/cupertino_router.dart';
import '../../theme/cupertino/theme_generator.dart';
import '../../theme/provider/theme_provider.dart';

class CupertinoResonApp extends ConsumerWidget {
  const CupertinoResonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeConfig = ref.watch(themeControllerProvider);

    return PlatformBrightnessListener(
      builder: (context, platformBrightness) {
        final effectiveBrightness = switch (themeConfig.themeMode) {
          ThemeMode.system => platformBrightness,
          ThemeMode.light => Brightness.light,
          ThemeMode.dark => Brightness.dark,
        };

        return CupertinoApp.router(
          title: 'Reson',
          theme: generateCupertinoTheme(brightness: effectiveBrightness, config: themeConfig),
          routerConfig: cupertinoRouter,
          locale: context.locale,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class PlatformBrightnessListener extends StatefulWidget {
  const PlatformBrightnessListener({super.key, required this.builder});

  final Widget Function(BuildContext context, Brightness brightness) builder;

  @override
  State<PlatformBrightnessListener> createState() => _PlatformBrightnessListenerState();
}

class _PlatformBrightnessListenerState extends State<PlatformBrightnessListener> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, WidgetsBinding.instance.platformDispatcher.platformBrightness);
  }
}
