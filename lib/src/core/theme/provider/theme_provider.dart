import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../deps/providers.dart';
import '../model/theme_config.dart';

class ThemeController extends Notifier<ThemeConfig> {
  static const _themeModeKey = 'theme_mode_index';
  static const _seedColorKey = 'theme_seed_color';
  static const _contrastLevelKey = 'theme_contrast_level';

  @override
  ThemeConfig build() {
    final prefs = ref.read(sharedPreferencesProvider);
    
    final modeIndex = prefs.getInt(_themeModeKey);
    final seedValue = prefs.getInt(_seedColorKey);
    final contrastIndex = prefs.getInt(_contrastLevelKey);

    return ThemeConfig(
      themeMode: modeIndex != null ? ThemeMode.values[modeIndex] : ThemeMode.system,
      seedColor: seedValue != null ? Color(seedValue) : ThemeConfig.defaultColor,
      contrastLevel: contrastIndex != null
          ? ContrastLevel.values[contrastIndex]
          : ContrastLevel.normal,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (state.themeMode == mode) return;
    state = state.copyWith(themeMode: mode);
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt(_themeModeKey, mode.index);
  }

  Future<void> setSeedColor(Color color) async {
    // ignore: deprecated_member_use
    if (state.seedColor.value == color.value) return;
    state = state.copyWith(seedColor: color);
    final prefs = ref.read(sharedPreferencesProvider);
    // ignore: deprecated_member_use
    await prefs.setInt(_seedColorKey, color.value);
  }

  Future<void> setContrastLevel(ContrastLevel level) async {
    if (state.contrastLevel == level) return;
    state = state.copyWith(contrastLevel: level);
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt(_contrastLevelKey, level.index);
  }
}

final themeControllerProvider = NotifierProvider<ThemeController, ThemeConfig>(ThemeController.new);