# App — Reson

The app layer is the composition root. It owns the registry of design-system variants and decides which one mounts. Everything else (`ui/`, `route/`, `theme/`) splits along the same axis **purely for separation** — they never choose, only provide.

## Files

All in `lib/core/app/`:

| File | Role |
|------|------|
| `app.dart` | `ResonApp` — picks the variant, hosts cross-cutting listeners. |
| `app_style.dart` | `AppStyle` enum + `AppStyleController` (Riverpod `Notifier`, persisted). The single registry of variants. |
| `material_app.dart` | `MaterialResonApp` — wires `MaterialApp.router`. |
| `cupertino_app.dart` | `CupertinoResonApp` — wires `CupertinoApp.router`; owns `PlatformBrightnessListener`. |

## How it works

```
main → bootstrap → ResonApp
                      │  ref.watch(appStyleControllerProvider)
                      ▼
        switch (AppStyle)
        ├── material → MaterialResonApp
        └── cupertino → CupertinoResonApp
```

- `AppStyleController.build()` reads the saved index from shared prefs (`AppPrefKey.appStyle`); default is `material`.
- `setStyle()` updates state and persists. Changing style swaps the whole app subtree on the next frame.
- `ResonApp` also listens to `localizationSyncProvider`: when background translation sync reports an update, it re-applies `context.setLocale(context.locale)` in a post-frame callback to hot-reload strings.

## Variant apps

Each variant app is a `ConsumerWidget` that reads `themeControllerProvider` and builds its platform widget with the same three ingredients: **theme**, **router**, **localization**.

```dart
MaterialApp.router(
  theme: generateTheme(brightness: Brightness.light, config: themeConfig),
  darkTheme: generateTheme(brightness: Brightness.dark, config: themeConfig),
  themeMode: themeConfig.themeMode,
  routerConfig: materialRouter,
  locale: context.locale,
  localizationsDelegates: context.localizationDelegates,
  supportedLocales: context.supportedLocales,
);
```

Cupertino has no `darkTheme` parameter, so brightness is resolved manually: `PlatformBrightnessListener` (a `WidgetsBindingObserver`) tracks the platform brightness and maps `ThemeMode.system` to it before generating a single `CupertinoThemeData`.

Localization delegates are mandatory in both variants — without them easy_localization never loads translations and `.tr()` renders raw keys.

## Rules

1. **The app layer is the only place that knows all variants.** Screens/widgets/routes/themes must not import across variants.
2. **Adding a variant** = new `AppStyle` value + `<variant>_app.dart` + matching folders in `route/<variant>/`, `theme/<variant>/`, `ui/<variant>/`.
3. Cross-cutting listeners (translation sync, future observers) live in `ResonApp`, not in variant apps.
