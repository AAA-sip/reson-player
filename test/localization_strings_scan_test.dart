import 'package:flutter_test/flutter_test.dart';

import '../tool/localization_strings_scan.dart';

void main() {
  group('collectIssuesFromSource', () {
    test('flags hardcoded Text literal', () {
      final issues = collectIssuesFromSource("Widget build() => Text('Hello world');", file: 'lib/a.dart');

      expect(issues, hasLength(1));
      expect(issues.single.file, 'lib/a.dart');
      expect(issues.single.line, 1);
      expect(issues.single.description, "hardcoded string 'Hello world'");
    });

    test('flags text-bearing parameter literals', () {
      final issues = collectIssuesFromSource("ActionWidget(title: 'History'),");

      expect(issues.single.description, "hardcoded string 'History'");
    });

    test('flags literals on a line below an open Text call', () {
      const source = '''
return Center(
  child: Text(
    'No song playing',
  ),
);
''';
      final issues = collectIssuesFromSource(source);

      expect(issues.single.description, "hardcoded string 'No song playing'");
      expect(issues.single.line, 3);
    });

    test('flags interpolated literal with static words', () {
      final issues = collectIssuesFromSource("subtitle: '\${playlist.numberOfSongs} Songs',");

      expect(issues, hasLength(1));
    });

    test('flags raw tr() usage', () {
      final issues = collectIssuesFromSource("Text('settings.title'.tr()),");

      expect(issues.map((issue) => issue.description), contains('raw tr()'));
    });

    test('ignores dynamic values and pure interpolations', () {
      const source = '''
Text(Strings.settings.title);
Text(localeDisplayName(locale));
subtitle: song.artist;
subtitle: '\$count';
label: item.label;
''';
      expect(collectIssuesFromSource(source), isEmpty);
    });

    test('ignores allowlisted brand values', () {
      expect(collectIssuesFromSource("const Text('Reson')"), isEmpty);
    });

    test('ignores non-text string positions', () {
      const source = '''
FontVariation('wght', 700);
fontFamily: 'RobotoFlex';
MaterialRoutes.home('/home');
extras!['song'];
''';
      expect(collectIssuesFromSource(source), isEmpty);
    });

    test('honors line-level ignore directive', () {
      const source = '''
// ignore: localization
Text('Not localized on purpose');
''';
      expect(collectIssuesFromSource(source), isEmpty);
    });

    test('honors file-level ignore directive', () {
      expect(collectIssuesFromSource("// ignore_for_file: localization\nText('Skip');"), isEmpty);
    });

    test('skips comment lines', () {
      expect(collectIssuesFromSource("// Text('just a comment');"), isEmpty);
    });
  });
}
