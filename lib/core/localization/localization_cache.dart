import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/logger.dart';
import '../utils/shared_pref/export.dart';

class LocalizationMeta {
  const LocalizationMeta({required this.hash, required this.updatedAt});

  final String hash;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => <String, dynamic>{'hash': hash, 'updatedAt': updatedAt.millisecondsSinceEpoch};

  static LocalizationMeta fromJson(Map<String, dynamic> json) => LocalizationMeta(
    hash: json['hash'] as String,
    updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int),
  );
}

///
///
/// Disk + prefs storage for downloaded translations.
/// Translations live as whole JSON files per locale, only tiny
/// meta (sha256 + timestamp) goes to SharedPreferences.
class LocalizationCache {
  LocalizationCache._();

  static Directory? _dir;

  static Future<void> init() async {
    final support = await getApplicationSupportDirectory();
    _dir = Directory('${support.path}/localization');
    if (!_dir!.existsSync()) {
      await _dir!.create(recursive: true);
    }
  }

  static Directory get _cacheDir {
    if (_dir == null) {
      logger.w('LocalizationCache is not initialized');
      throw Exception('LocalizationCache is not initialized');
    }
    return _dir!;
  }

  static File _fileFor(String languageCode) => File('${_cacheDir.path}/$languageCode.json');

  /// Cached translations for locale or null.
  static Map<String, dynamic>? read(String languageCode) {
    try {
      final file = _fileFor(languageCode);
      if (!file.existsSync()) return null;
      final decoded = jsonDecode(file.readAsStringSync());
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (e) {
      logger.w('LocalizationCache read failed for $languageCode: $e');
      return null;
    }
  }

  static void write(String languageCode, String rawJsonBody) {
    try {
      _fileFor(languageCode).writeAsStringSync(rawJsonBody, flush: true);
      saveMeta(languageCode, translationsHash(rawJsonBody));
    } catch (e) {
      logger.w('LocalizationCache write failed for $languageCode: $e');
    }
  }

  static LocalizationMeta? metaOf(String languageCode) {
    final all = decodeMeta(SharedPrefManager.getData<String>(LocalizationPrefKey.translationsMeta));
    return all[languageCode];
  }

  static void saveMeta(String languageCode, String hash) {
    final all = decodeMeta(SharedPrefManager.getData<String>(LocalizationPrefKey.translationsMeta));
    all[languageCode] = LocalizationMeta(hash: hash, updatedAt: DateTime.now());
    SharedPrefManager.saveData(LocalizationPrefKey.translationsMeta, encodeMeta(all));
  }

  static void remove(String languageCode) {
    try {
      final file = _fileFor(languageCode);
      if (file.existsSync()) file.deleteSync();
    } catch (e) {
      logger.w('LocalizationCache remove failed for $languageCode: $e');
    }
  }
}

/// Bundled (base) translations merged with newer cached ones,
/// cache wins on conflicts.
Map<String, dynamic> mergeTranslations(Map<String, dynamic>? base, Map<String, dynamic>? override) {
  final result = <String, dynamic>{};
  if (base != null) result.addAllRecursive(base);
  if (override != null) result.addAllRecursive(override);
  return result;
}

extension _DeepMerge on Map<String, dynamic> {
  void addAllRecursive(Map<String, dynamic> other) {
    other.forEach((key, value) {
      final existing = this[key];
      if (existing is Map<String, dynamic> && value is Map<String, dynamic>) {
        existing.addAllRecursive(value);
      } else {
        this[key] = value;
      }
    });
  }
}

String translationsHash(String rawBody) => sha256.convert(utf8.encode(rawBody)).toString();

String encodeMeta(Map<String, LocalizationMeta> meta) =>
    jsonEncode(meta.map((key, value) => MapEntry(key, value.toJson())));

Map<String, LocalizationMeta> decodeMeta(String? raw) {
  if (raw == null || raw.isEmpty) return <String, LocalizationMeta>{};
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) return <String, LocalizationMeta>{};
    return decoded.map((key, value) => MapEntry(key, LocalizationMeta.fromJson(value as Map<String, dynamic>)));
  } catch (e) {
    logger.w('decodeMeta failed: $e');
    return <String, LocalizationMeta>{};
  }
}
