import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/shared_pref/export.dart';
import '../model/theme_config.dart';

class ThemeController extends Notifier<ThemeConfig> {
  //
  @override
  ThemeConfig build() {
    final modeIndex = SharedPrefManager.getData<int>(ThemePrefKey.themeMode);

    final seedValue = SharedPrefManager.getData<int>(ThemePrefKey.seedColor);

    final contrastIndex = SharedPrefManager.getData<int>(ThemePrefKey.contrastLevel);

    return ThemeConfig(
      themeMode: modeIndex != null ? ThemeMode.values[modeIndex] : ThemeMode.system,
      seedColor: seedValue != null ? Color(seedValue) : ThemeConfig.defaultColor,
      contrastLevel: contrastIndex != null ? ContrastLevel.values[contrastIndex] : ContrastLevel.normal,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (state.themeMode == mode) return;

    state = state.copyWith(themeMode: mode);

    await SharedPrefManager.saveData(ThemePrefKey.themeMode, mode.index);
  }

  Future<void> setSeedColor(Color color) async {
    if (state.seedColor.toARGB32() == color.toARGB32()) return;

    state = state.copyWith(seedColor: color);

    await SharedPrefManager.saveData(ThemePrefKey.seedColor, color.toARGB32());
  }

  Future<void> setContrastLevel(ContrastLevel level) async {
    if (state.contrastLevel == level) return;

    state = state.copyWith(contrastLevel: level);

    await SharedPrefManager.saveData(ThemePrefKey.contrastLevel, level.index);
  }
}

final themeControllerProvider = NotifierProvider<ThemeController, ThemeConfig>(ThemeController.new);
