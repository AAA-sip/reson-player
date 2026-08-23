import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:reson/core/localization/localization_cache.dart';

void main() {
  group('mergeTranslations', () {
    test('returns empty for two nulls', () {
      expect(mergeTranslations(null, null), <String, dynamic>{});
    });

    test('base survives when override is null', () {
      final result = mergeTranslations(<String, dynamic>{
        'player': <String, dynamic>{'title': 'Player'},
      }, null);

      expect(result['player']['title'], 'Player');
    });

    test('override wins on flat conflicts', () {
      final result = mergeTranslations(<String, dynamic>{'title': 'bundled'}, <String, dynamic>{'title': 'cached'});

      expect(result['title'], 'cached');
    });

    test('merges nested maps recursively, cache wins deep', () {
      final result = mergeTranslations(
        <String, dynamic>{
          'settings': <String, dynamic>{
            'theme': 'Theme',
            'player': <String, dynamic>{'volume': 'Volume'},
          },
        },
        <String, dynamic>{
          'settings': <String, dynamic>{
            'player': <String, dynamic>{'volume': 'Громкость'},
            'new_key': 'New',
          },
        },
      );

      expect(result['settings']['theme'], 'Theme');
      expect(result['settings']['player']['volume'], 'Громкость');
      expect(result['settings']['new_key'], 'New');
    });
  });

  group('translationsHash', () {
    test('is stable for identical input', () {
      expect(translationsHash('{"a":"b"}'), translationsHash('{"a":"b"}'));
    });

    test('changes when content changes', () {
      expect(translationsHash('{"a":"b"}'), isNot(translationsHash('{"a":"c"}')));
    });
  });

  group('meta codec', () {
    test('encode/decode roundtrip', () {
      final meta = <String, LocalizationMeta>{'ru': LocalizationMeta(hash: 'abc123', updatedAt: DateTime(2026, 8, 23))};

      final decoded = decodeMeta(encodeMeta(meta));

      expect(decoded['ru']!.hash, 'abc123');
      expect(decoded['ru']!.updatedAt, DateTime(2026, 8, 23));
    });

    test('decode handles garbage gracefully', () {
      expect(decodeMeta(null), isEmpty);
      expect(decodeMeta(''), isEmpty);
      expect(decodeMeta('not json'), isEmpty);
      expect(decodeMeta(jsonEncode(<String, dynamic>{})), isEmpty);
    });
  });
}
