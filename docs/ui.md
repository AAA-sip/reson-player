# UI — Reson

Material Design 3 is the primary design system; a Cupertino variant exists as a separate implementation of the same screens.

## Responsibility boundary

`lib/ui/` is split by theme (`material/`, `cupertino/`) **purely to separate implementations**. Choosing which variant mounts and all app-level composition live in the `app` layer (`lib/core/app/`). Screens never import across themes and never import app wiring.

## Folder structure

One folder per screen. The folder name equals the screen name.

```
lib/ui/
├── material/
│   ├── _shared/                      # reusable within this theme only
│   └── home/                         # folder name = screen name
│       ├── home_screen.dart          # the ONLY file at screen root
│       ├── state/
│       │   └── home_state.dart
│       └── widgets/
│           ├── appbar_widget.dart
│           ├── tracks_widget.dart
│           ├── tracks/               # children of tracks_widget (no _widget)
│           │   └── tile_widget.dart
│           ├── albums_widget.dart
│           ├── albums/
│           │   └── cart_widget.dart
│           └── actions_widget.dart
└── cupertino/
    ├── _shared/
    └── home/
        └── ...
```

## Naming

| What | Rule | Example |
|------|------|---------|
| Screen | `<name>_screen.dart`, one per screen folder | `home_screen.dart` |
| Widget | `<name>_widget.dart` — mandatory `_widget` suffix | `tile_widget.dart` |
| Appbar | It is a widget → `_widget` suffix | `appbar_widget.dart` |
| Screen state | `state/<name>_state.dart` | `state/home_state.dart` |
| Child-widget folder | Widget name without `_widget` | `tracks_widget.dart` → `tracks/` |

No other suffixes. Former `*_section.dart` files are widgets (`tracks_widget.dart`).

**Widget names are generic — never prefixed with the screen name.** The folder is the namespace: the appbar of home is `appbar_widget.dart` / `AppBarWidget`, not `home_appbar_widget.dart` / `HomeAppBarWidget`. Identical names may repeat across screen folders (two `TileWidget`s, two `AppBarWidget`s) — they live in different libraries and are never imported together; the folder disambiguates. Class names mirror file names in PascalCase.

## Screen anatomy

A screen folder contains, in this order:

1. `<screen>_screen.dart` — always present, always the single file at root.
2. `state/` — Riverpod providers for the screen. Omit if the screen has no state.
3. `widgets/` — everything rendered by the screen. Omit if trivially small (inline into the screen).

## Nested widgets

A widget lives next to its children, children go in a folder:

- `widgets/tracks_widget.dart` stays at the `widgets/` level.
- Widgets used **only** by `tracks_widget` go into `widgets/tracks/`.

The rule recurses: if `tracks/tile_widget.dart` gets its own children, create `tracks/tile/`. A folder is created only when children exist — never preemptively. A widget moves down into its folder only when someone else starts reusing it (then it likely belongs in `_shared/` anyway).

## _shared

Widgets reused by **2+ screens within the same theme** live in `lib/ui/<theme>/_shared/`. Same naming and nesting rules apply. Anything needed across themes belongs in `core/` or `service/`, not here.

## State (Riverpod 3)

Providers live in `state/<screen>_state.dart` using manual providers (no codegen):

```dart
final songsProvider = FutureProvider<List<SongModel>>((ref) async {
  final service = ref.watch(mediaStoreServiceProvider);
  return service.getSongs();
});
```

Reach for `Provider` / `FutureProvider` / `StreamProvider` / `NotifierProvider` / `AsyncNotifierProvider`. `ref.watch` in build, `ref.read` in callbacks. Detailed type guidance lives in `docs/state.md`.

## Rules

1. **Screens are Stateless/ConsumerWidgets.** Logic goes to `state/`, never into build methods.
2. **Widgets don't know each other.** The screen composes them.
3. **No wrapper widgets for their own sake.** If a widget isn't reused, inline it.
4. **Sizes:** integers only, no fractions.
5. **Spacing:** multiples of 4 or 8.
6. **Theming through `Theme.of(context)`** — no hardcoded colors or text styles.

## Theme generation

Fonts/colors come from seed color via `flex_seed_scheme` (`theme/material/theme_generator.dart`): contrast levels normal / medium / high, mode system / light / dark. The player forces a dark variant locally by wrapping in `Theme(data: generateTheme(brightness: Brightness.dark, ...))`. See `docs/theme.md`.
