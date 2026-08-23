import 'dart:convert';

import '../core/localization/localization_cache.dart';
import '../core/localization/localization_loader.dart';
import '../core/utils/logger.dart';
import 'tolgee_service.dart';

///
///
/// Revalidates the current locale's translations against Tolgee
/// once per app session. If the content hash changed, refreshes
/// the cache file; caller can hot-reload strings afterwards.
class LocalizationSyncService {
  LocalizationSyncService._();

  static bool _done = false;

  /// Returns true when cached strings were updated and UI should reload.
  static Future<bool> revalidate() async {
    if (_done) return false;
    _done = true;

    try {
      final code = currentLanguageGuess();
      final raw = await tolgeeService.exportLocaleRaw(code);

      final meta = LocalizationCache.metaOf(code);
      if (meta != null && meta.hash == translationsHash(raw)) {
        logger.i('Localization for $code is up to date');
        return false;
      }

      // Nothing translated yet on Tolgee side, keep bundled fallback.
      final decoded = jsonDecode(raw);
      if (meta == null && decoded is Map && decoded.isEmpty) {
        logger.i('Tolgee has no $code translations yet');
        return false;
      }

      logger.i('Localization for $code changed, updating cache');
      LocalizationCache.write(code, raw);
      return true;
    } catch (e) {
      logger.w('Localization sync failed: $e');
      return false;
    }
  }
}
