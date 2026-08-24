# Theme — Reson

Theming is split into a **shared user preference** (one setting for the whole app) and **self-contained generators per design-system variant**.

## Structure

```
lib/theme/
├── model/
│   └── theme_config.dart         # ThemeConfig — shared preference model
├── provider/
│   └── theme_provider.dart       # ThemeController — shared Riverpod state
├── theme_util.dart               # shared helper
├── material/
│   └── theme_generator.dart      # generateTheme → ThemeData
└── cupertino/
    └── theme_generator.dart      # generateCupertinoTheme → CupertinoThemeData
```

Note: generation currently lives in a single flat `theme_generator.dart` holding both functions; it splits into variant folders as part of adopting this convention.

## Shared preference (theme root)

`ThemeConfig` is one user setting applied identically by every generator:

| Field | Meaning | Persisted under |
|-------|---------|-----------------|
| `seedColor` | Brand color, seeds every palette | `ThemePrefKey.seedColor` |
| `contrastLevel` | `normal` / `medium` / `high` tonal contrast | `ThemePrefKey.contrastLevel` |
| `themeMode` | `system` / `light` / `dark` | `ThemePrefKey.themeMode` |

`ThemeController` (Riverpod `Notifier`) loads defaults on first run (`Colors.deepPurple`, `normal`, `system`) and persists every change. It knows nothing about variants — that is why it stays at `theme/` root instead of being duplicated per variant.

## Generators (self-contained per variant)

Each `<variant>/theme_generator.dart` turns the shared config into that variant's theme object and depends only on `ThemeConfig`:

- `generateTheme(brightness, config)` → Material 3 `ThemeData`: `SeedColorScheme.fromSeeds` + RobotoFlex text theme.
- `generateCupertinoTheme(brightness, config)` → `CupertinoThemeData` derived from the same seed scheme.

Tonal contrast maps through flex_seed_scheme tones:

| ContrastLevel | Tones |
|---------------|-------|
| normal | `FlexTones.material(brightness)` |
| medium | `FlexTones.highContrast(brightness)` |
| high | `FlexTones.highContrast(brightness).onMainsUseBW()` |

Brightness handling differs per platform widget: Material gets `theme` + `darkTheme` + `themeMode`; Cupertino resolves brightness manually (see `docs/app.md`, `PlatformBrightnessListener`) and generates one theme.

The player forces dark locally regardless of app mode:

```dart
Theme(data: generateTheme(brightness: Brightness.dark, config: themeConfig), child: ...)
```

## Rules

1. **Generators are pure functions**: `(brightness, ThemeConfig) → theme object`. No providers, no prefs, no context.
2. **Never duplicate `ThemeConfig`/`ThemeController`** — they are the single shared setting.
3. Widgets consume themes through `Theme.of(context)` / Cupertino equivalents; no hardcoded colors.
4. **Adding a design system** = new generator in `theme/<app>/` + new `AppStyle` value (see `docs/app.md`). The registry is `AppStyle`, not folders.
