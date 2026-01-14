import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'model/theme_config.dart';

ThemeData generateTheme({
  required Brightness brightness,
  required ThemeConfig config,
}) {
  final tones = _getTones(config.contrastLevel, brightness);

  final colorScheme = SeedColorScheme.fromSeeds(
    brightness: brightness,
    primaryKey: config.seedColor,
    tones: tones,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    textTheme: GoogleFonts.interTextTheme(
      ThemeData(brightness: brightness).textTheme,
    ),
  );
}

FlexTones _getTones(ContrastLevel level, Brightness brightness) {
  switch (level) {
    case ContrastLevel.normal:
      return FlexTones.material(brightness);
    case ContrastLevel.medium:
      return FlexTones.highContrast(brightness);
    case ContrastLevel.high:
      // More aggressive contrast, forcing black/white on mains
      return FlexTones.highContrast(brightness).onMainsUseBW();
  }
}
