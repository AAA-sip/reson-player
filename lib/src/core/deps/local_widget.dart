import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/material.dart';

class LocalWidget extends StatelessWidget {
  const LocalWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(_) =>
      //
      EasyLocalization(
        supportedLocales: <Locale>[
          const Locale('en'),
          const Locale('ru'),
          const Locale('kk'),
        ],
        path: 'assets/local',
        fallbackLocale: const Locale('ru'),
        assetLoader: const YamlAssetLoader(),
        child: child,
      );
}
