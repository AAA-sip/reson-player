import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../localization/localization_loader.dart';

class LocalBootstrap extends StatelessWidget {
  const LocalBootstrap({super.key, required this.app});

  final Widget app;

  @override
  Widget build(_) =>
      //
      EasyLocalization(
        supportedLocales: <Locale>[const Locale('en'), const Locale('ru'), const Locale('kk')],
        path: 'assets/local',
        fallbackLocale: const Locale('en'),
        assetLoader: const LocalizationLoader(),
        child: app,
      );
}
