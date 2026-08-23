import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

import '../../service/tolgee_service.dart';
import '../utils/logger.dart';
import '../utils/shared_pref/_export.dart';
import 'localization_cache.dart';

/// Loads translations for easy_localization.
///
/// Merge order: bundled assets (en only) <- downloaded cache.
/// On cache miss downloads just this locale from Tolgee,
/// offline failure falls back to bundled strings.
class LocalizationLoader extends AssetLoader {
  const LocalizationLoader();

  static final Map<String, Future<void>> _inflight = <String, Future<void>>{};

  /// Fire-and-forget download so the first EasyLocalization load
  /// usually finds the file already cached (parallel with engine warmup).
  static void warmup(String languageCode) {
    if (LocalizationCache.read(languageCode) != null) return;
    unawaited(downloadIfMissing(languageCode));
  }

  static Future<void> downloadIfMissing(String languageCode) {
    final existing = _inflight[languageCode];
    if (existing != null) return existing;

    final future = _download(languageCode).whenComplete(() {
      _inflight.remove(languageCode);
    });
    _inflight[languageCode] = future;
    return future;
  }

  static Future<void> _download(String languageCode) async {
    try {
      final raw = await tolgeeService.exportLocaleRaw(languageCode);
      LocalizationCache.write(languageCode, raw);
    } catch (e) {
      logger.w('Localization download failed for $languageCode: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    final code = locale.languageCode;

    final bundled = await _readBundled('$path/$code.json');
    final cached = LocalizationCache.read(code);
    if (cached != null) {
      return mergeTranslations(bundled, cached);
    }

    try {
      await downloadIfMissing(code);
    } catch (_) {
      // Already logged; bundled fallback is enough.
    }
    return mergeTranslations(bundled, LocalizationCache.read(code));
  }

  static Future<Map<String, dynamic>?> _readBundled(String assetPath) async {
    try {
      final decoded = jsonDecode(await rootBundle.loadString(assetPath));
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (e) {
      logger.w('Bundled translations not found at $assetPath');
      return null;
    }
  }
}

/// Best-effort current language guess:
/// easy_localization saved value first, then device locale.
String currentLanguageGuess() {
  final saved = SharedPrefManager.getData<String>(LocalizationPrefKey.easySavedLocale);
  final raw = (saved != null && saved.isNotEmpty) ? saved : Platform.localeName;
  final normalized = raw.split(RegExp('[_-]')).first.toLowerCase();
  return normalized;
}
