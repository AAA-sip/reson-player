import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../localization/localization_loader.dart';
import '../../localization/supported_locales.dart';

class LocalBootstrap extends StatelessWidget {
  const LocalBootstrap({super.key, required this.app});

  final Widget app;

  @override
  Widget build(_) =>
      //
      EasyLocalization(
        supportedLocales: supportedLocales,
        path: 'assets/local',
        fallbackLocale: const Locale('en'),
        assetLoader: const LocalizationLoader(),
        child: app,
      );
}
