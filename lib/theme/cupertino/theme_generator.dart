import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/material.dart';

import '../model/theme_config.dart';
import '../theme_util.dart';

CupertinoThemeData generateCupertinoTheme({required Brightness brightness, required ThemeConfig config}) {
  final colorScheme = SeedColorScheme.fromSeeds(
    brightness: brightness,
    primaryKey: config.seedColor,
    tones: tonesFor(config.contrastLevel, brightness),
  );

  return CupertinoThemeData(
    brightness: brightness,
    primaryColor: colorScheme.primary,
    scaffoldBackgroundColor: colorScheme.surface,
    barBackgroundColor: colorScheme.surface,
  );
}
