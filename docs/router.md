# Router — Reson

Routing is split by design-system variant. Each variant owns a **self-contained** folder under `lib/route/` — its own router, path enum, screen exports, shell, and (soon) observers. No shared files between variants.

## Structure

```
lib/route/
├── material/
│   ├── material_router.dart      # GoRouter instance
│   ├── routes.dart               # MaterialRoutes path enum
│   ├── screens.dart              # exports of this variant's screens
│   ├── shell/
│   │   └── screen_with_player.dart
│   └── observer/                 # future: navigator observers
└── cupertino/
    ├── cupertino_router.dart
    ├── routes.dart               # CupertinoRoutes path enum
    ├── screens.dart
    └── shell/                    # cupertino shell lands here
    └── observer/
```

Note: the codebase currently keeps these files flat at `lib/route/` root (`material_router.dart`, `screens.dart`, `shell/`); they move into variant folders as part of adopting this convention.

## Anatomy of a variant folder

| File | Role |
|------|------|
| `<app>_router.dart` | The `GoRouter` instance for this variant, wired into `*App.router(routerConfig: ...)`. |
| `routes.dart` | Enum of paths — the single source of route constants. |
| `screens.dart` | Exports of the variant's screens from `ui/<app>/`. |
| `shell/` | Shell widgets that persist across tab-level navigation (e.g. mini player overlay). |
| `observer/` | Per-variant navigator observers when needed. |

## Patterns (go_router 17)

Path constants live in an enum:

```dart
enum MaterialRoutes {
  home('/home'),
  player('/player');

  final String path;
  const MaterialRoutes(this.path);
}
```

Tab-level screens ride a `ShellRoute` so the shell (mini player) survives navigation:

```dart
ShellRoute(
  navigatorKey: _shellNavigatorKey,
  builder: (_, _, child) => ScreenWithPlayer(child: child),
  routes: [
    GoRoute(path: MaterialRoutes.home.path, builder: (_, _) => const HomeScreen()),
    ...
  ],
)
```

Full-screen destinations mount on the **root** navigator via `parentNavigatorKey`:

```dart
GoRoute(
  parentNavigatorKey: _rootNavigatorKey,
  path: MaterialRoutes.player.path,
  builder: (_, _) => const PlayerScreen(),
),
```

Cupertino transitions use explicit pages:

```dart
GoRoute(
  path: CupertinoRoutes.home.path,
  pageBuilder: (_, state) => CupertinoPage(key: state.pageKey, child: const CupertinoHomeScreen()),
),
```

## Rules

1. **One variant never imports another's router, routes, or screens.**
2. A new screen = new enum value + `GoRoute` + export in that variant's `screens.dart`.
3. Shell widgets belong in `shell/`, observers in `observer/` — never inline into the router file once they grow.
4. Route paths are strings only through the enum; no raw path literals in builders.
