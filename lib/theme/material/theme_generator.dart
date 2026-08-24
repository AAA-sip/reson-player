import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/material.dart';

import '../model/theme_config.dart';
import '../theme_util.dart';

ThemeData generateTheme({required Brightness brightness, required ThemeConfig config}) {
  final tones = tonesFor(config.contrastLevel, brightness);
  final colorScheme = SeedColorScheme.fromSeeds(brightness: brightness, primaryKey: config.seedColor, tones: tones);
  final baseTextTheme = ThemeData(brightness: brightness).textTheme;

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    textTheme: baseTextTheme.apply(fontFamily: 'RobotoFlex'),
  );
}
