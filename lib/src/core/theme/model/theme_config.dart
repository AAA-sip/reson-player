import 'package:flutter/material.dart';

enum ContrastLevel {
  normal,
  medium,
  high;
}

class ThemeConfig {
  final ThemeMode themeMode;
  final Color seedColor;
  final ContrastLevel contrastLevel;

  const ThemeConfig({
    this.themeMode = ThemeMode.system,
    required this.seedColor,
    this.contrastLevel = ContrastLevel.normal,
  });

  ThemeConfig copyWith({
    ThemeMode? themeMode,
    Color? seedColor,
    ContrastLevel? contrastLevel,
  }) {
    return ThemeConfig(
      themeMode: themeMode ?? this.themeMode,
      seedColor: seedColor ?? this.seedColor,
      contrastLevel: contrastLevel ?? this.contrastLevel,
    );
  }

  static const defaultColor = Colors.deepPurple;
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ThemeConfig &&
        other.themeMode == themeMode &&
        // ignore: deprecated_member_use
        other.seedColor.value == seedColor.value &&
        other.contrastLevel == contrastLevel;
  }

  @override
  // ignore: deprecated_member_use
  int get hashCode => Object.hash(themeMode, seedColor.value, contrastLevel);
}