///
///
/// Main abstract class for shared preference keys.
abstract class SharedPrefKey {
  const SharedPrefKey(this.name);

  final String name;
}

/// AppPrefKey extending [SharedPrefKey].
class AppPrefKey extends SharedPrefKey {
  const AppPrefKey(super.name);

  static const token = AppPrefKey('token');
  static const userId = AppPrefKey('userId');
}

/// ThemePrefKey extending [SharedPrefKey].
class ThemePrefKey extends SharedPrefKey {
  const ThemePrefKey(super.name);

  static const themeMode = ThemePrefKey('theme_mode_index');
  static const seedColor = ThemePrefKey('theme_seed_color');
  static const contrastLevel = ThemePrefKey('theme_contrast_level');
}
