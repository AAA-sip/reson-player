// Scans lib/ sources for unlocalized user-facing strings and raw tr() usage.
//
// Consumers: tool/check_localization.dart
//
// The scan is advisory tooling: it reports findings, it does not decide
// policy. Opt out where localization genuinely does not apply:
//   // ignore: localization            (on the line or above it)
//   // ignore_for_file: localization   (anywhere in the file)

import 'dart:io';

const localizationScanRoot = 'lib';
const generatedStringsPath = 'lib/core/localization/strings.g.dart';

/// Literal values that never need translation (brand names and similar).
const localizationAllowlist = <String>{'Reson'};

const _ignoreLineMarker = '// ignore: localization';
const _ignoreFileMarker = '// ignore_for_file: localization';

final _rawTrPattern = RegExp(r'\btr\s*\(');
final _textCallPattern = RegExp(r'\bText\s*\(\s*$');
final _textParamPattern = RegExp(
  r'\b(?:title|subtitle|label|hintText|tooltip|message|semanticLabel|placeholder|header|middle|content|helperText)\s*:\s*$',
);
final _stringLiteralPattern = RegExp(r''''(?:\\.|[^'\\])*'|"(?:\\.|[^"\\])*"''');
final _interpolationPattern = RegExp(r'\$\{[^}]*\}|\$[A-Za-z_]\w*');
final _letterPattern = RegExp(r'\p{L}', unicode: true);

class LocalizationIssue {
  final String file;
  final int line;
  final int column;
  final String description;

  const LocalizationIssue({required this.file, required this.line, required this.column, required this.description});
}

String formatLocalizationIssue(LocalizationIssue issue) {
  return '${issue.file}:${issue.line}:${issue.column} — ${issue.description} — use Strings.*';
}

List<LocalizationIssue> collectIssuesFromSource(String source, {String file = 'lib'}) {
  if (source.contains(_ignoreFileMarker)) return const [];

  final issues = <LocalizationIssue>[];
  final lines = source.split('\n');

  void report(int line, int column, String description) {
    if (lines[line - 1].contains(_ignoreLineMarker)) return;
    if (line >= 2 && lines[line - 2].contains(_ignoreLineMarker)) return;
    issues.add(LocalizationIssue(file: file, line: line, column: column, description: description));
  }

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (_isCommentLine(line)) continue;
    for (final match in _rawTrPattern.allMatches(line)) {
      report(i + 1, match.start + 1, 'raw tr()');
    }
  }

  var offset = 0;
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (_isCommentLine(line)) {
      offset += line.length + 1;
      continue;
    }
    for (final match in _stringLiteralPattern.allMatches(line)) {
      final literal = match.group(0)!;
      final content = literal.substring(1, literal.length - 1);
      if (localizationAllowlist.contains(content)) continue;
      final staticText = content.replaceAll(_interpolationPattern, '');
      if (!_letterPattern.hasMatch(staticText)) continue;

      final before = source.substring(
        (offset + match.start - 300).clamp(0, offset + match.start),
        offset + match.start,
      );
      final isTextCall = _textCallPattern.hasMatch(before);
      final isTextParam = _textParamPattern.hasMatch(before);
      if (!isTextCall && !isTextParam) continue;

      report(i + 1, match.start + 1, "hardcoded string '$content'");
    }
    offset += line.length + 1;
  }

  return issues;
}

List<LocalizationIssue> collectLibIssues({String root = localizationScanRoot}) {
  final issues = <LocalizationIssue>[];
  final rootDir = Directory(root);
  if (!rootDir.existsSync()) return issues;

  final files =
      rootDir.listSync(recursive: true).whereType<File>().where((file) => file.path.endsWith('.dart')).toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  for (final file in files) {
    if (file.path == generatedStringsPath) continue;
    issues.addAll(collectIssuesFromSource(file.readAsStringSync(), file: file.path));
  }
  return issues;
}

bool _isCommentLine(String line) => line.trimLeft().startsWith('//');
