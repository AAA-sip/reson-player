# Localization — easy_localization + Tolgee

Tolgee Cloud is the source of truth for translations. Only English is bundled in the APK; every other locale is downloaded once per device, cached on disk, and kept fresh by hash comparison.

## Flow

```
first launch                     next launches                    once per session
─────────────                    ─────────────                    ────────────────
device locale                    bundled en.json                  localizationSyncProvider:
    ↓                            + disk cache (if any)              fetch raw export
LocalizationLoader               merged by loader                   compare sha256 vs meta
downloads <code>.json                ↓                              if changed → rewrite
to disk                          .tr() / Strings.*                  cache + meta
```

Hot reload after a sync: `ResonApp` listens to `localizationSyncProvider` and re-applies `context.setLocale` when the cache changed.

## Files

| File | Role |
|------|------|
| `assets/local/en.json` | Bundled English. Source of truth for key structure and for the generator. |
| `lib/service/tolgee_service.dart` | REST client (dio). `exportLocaleRaw(code)`. Treats Tolgee's 400 `no_exported_result` as `{}`. |
| `lib/core/localization/localization_cache.dart` | Disk cache (`<app support>/localization/<code>.json`) + tiny hash meta in shared prefs. Pure helpers: `mergeTranslations`, `translationsHash`. |
| `lib/core/localization/localization_loader.dart` | Custom `AssetLoader` for easy_localization. Merges bundled + cached, downloads missing locales (in-flight deduped). |
| `lib/service/localization_sync_service.dart` | Once-per-session revalidation: fetch, compare hash, refresh cache. |
| `lib/service/providers.dart` | `tolgeeServiceProvider`, `localizationSyncProvider`. |
| `lib/core/localization/strings.g.dart` | **Generated** typed accessors (`Strings.settings.title`). Never edit by hand. |
| `lib/core/localization/supported_locales.dart` | Single source of supported locales + native display names. |
| `tool/generate_localization_keys.dart` | Generator script. Run via `task l10n-gen`. |
| `lib/core/utils/shared_pref/shared_pref_keys.dart` | `LocalizationPrefKey` (`translations_meta`, easy_localization's saved `locale`). |

## Versioning

No manual version keys. Per-locale metadata lives in shared prefs under `translations_meta`:

```json
{ "ru": { "hash": "<sha256 of raw export body>", "updatedAt": "..." } }
```

Sync re-fetches the export, hashes it, and rewrites the cache only when the hash differs — one cheap HTTP call per locale per session.

Merge order: cached translations override bundled ones (`mergeTranslations(bundled, cached)`), so fresh server data wins over a stale bundled file.

## Keys

- Nested JSON; nesting maps to dotted keys (`settings.title`).
- Add keys to `en.json` → `task l10n-gen` → use `Strings.settings.title` in UI.
- Prefer typed accessors over raw `'key'.tr()`.
- Full procedure: `.skills/localization-app/SKILL.md`.
- Nested sections chain through instances (`Strings.home.actions.history`); only the root accessors are static.

## Hardcoded string scan

`task l10n-check` validates `en.json`, verifies `strings.g.dart` is in sync, **and scans every `lib/**/*.dart`** for unlocalized UI strings.

Flagged:

- String literals with static text in text positions: `Text('...')` and text-bearing params (`title:`, `subtitle:`, `label:`, `hintText:`, `tooltip:`, `message:`, `semanticLabel:`, `placeholder:`, `header:`, `middle:`, `content:`, `helperText:`). Literals need at least one letter outside interpolation, so pure-number templates (`'$count'`) and composed values (`'${Strings.common.error}: $err'`) pass.
- Raw `tr()` outside the generated file — use `Strings.*`.

Not flagged:

- Values in `localizationAllowlist` (`tool/localization_strings_scan.dart`) — currently the brand name `Reson`.
- Lines marked `// ignore: localization` (on the line or above it).
- Files marked `// ignore_for_file: localization`.

The check is a helper, not a mandate: findings fail the task, but a string that genuinely must not be localized is opted out with an explicit ignore marker — visible in code, never silent. When violations exist, the report ends with a section listing which git-changed files still contain them.

Known limitation: generated accessors have no plural/named-args support yet. Compose instead: `'${playlist.numberOfSongs} ${Strings.common.songs}'`.

## App wiring (do not break)

`MaterialApp` and `CupertinoApp` and other `App` must register:

```dart
locale: context.locale,
localizationsDelegates: context.localizationDelegates,
supportedLocales: context.supportedLocales,
```

Without delegates, translations are never loaded and `.tr()` renders raw keys — this was a real bug once. Covered by `test/localization_loader_test.dart`.

Bootstrap order in `lib/core/deps/init.dart`: dotenv → shared prefs → `EasyLocalization.ensureInitialized()` → `LocalizationCache.init()` → `LocalizationLoader.warmup(currentLanguageGuess())`.

## Adding a locale

1. Add the language in Tolgee project settings.
2. Add its `Locale` + native name to `supported_locales.dart`.
3. Done — users get it automatically on first launch.

## Tolgee API recipes

All requests use header `X-API-Key: $TOLGEE_API_KEY` against `$TOLGEE_API_URL` (from `.env`; gitignored, template in `.envcopy`). The key ships inside the app bundle as an asset — acceptable for read-only public translation data, rotate it if it leaks.

Export one locale (raw JSON, no zip):

```bash
curl "$TOLGEE_API_URL/v2/projects/export?languages=ru&format=JSON&filterState=TRANSLATED&filterState=REVIEWED&zip=false" \
  -H "X-API-Key: $TOLGEE_API_KEY"
```

HTTP 400 with code `no_exported_result` means "nothing matches the filter" — the service maps it to `{}`.

Import bundled en.json (two steps):

```bash
curl -X POST "$TOLGEE_API_URL/v2/projects/import" \
  -H "X-API-Key: $TOLGEE_API_KEY" \
  -F "files=@assets/local/en.json"
curl -X PUT "$TOLGEE_API_URL/v2/projects/import/apply?forceMode=OVERRIDE" \
  -H "X-API-Key: $TOLGEE_API_KEY"
```

The apply step is a **PUT** with the mode as a query param; `POST .../apply` returns 405.
