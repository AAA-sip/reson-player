// Validates bundled English strings, checks that typed accessors are in sync,
// and scans lib/ for hardcoded user-facing strings and raw tr() usage.
// Exits non-zero on any problem.
//
// Usage: dart run tool/check_localization.dart

import 'dart:convert';
import 'dart:io';

import 'localization_codegen.dart';
import 'localization_strings_scan.dart';

void main() {
  final source = File(enJsonPath);
  if (!source.existsSync()) {
    stderr.writeln('Input file not found: $enJsonPath');
    exitCode = 1;
    return;
  }

  final Object? decoded;
  try {
    decoded = jsonDecode(source.readAsStringSync());
  } on FormatException catch (error) {
    stderr.writeln('$enJsonPath is not valid JSON: ${error.message}');
    exitCode = 1;
    return;
  }
  if (decoded is! Map<String, dynamic>) {
    stderr.writeln('$enJsonPath must contain a JSON object at the top level');
    exitCode = 1;
    return;
  }

  final problems = collectEnJsonProblems(decoded);

  final expected = generateStringsSource(decoded);
  final actual = File(stringsDartPath);
  if (!actual.existsSync() || actual.readAsStringSync() != expected) {
    problems.add('$stringsDartPath is out of date — run `task l10n-gen`');
  }

  final issues = collectLibIssues();

  if (problems.isEmpty && issues.isEmpty) {
    stdout.writeln('Localization check passed');
    return;
  }

  stderr.writeln('Localization check failed:');
  for (final problem in problems) {
    stderr.writeln('  - $problem');
  }
  for (final issue in issues) {
    stderr.writeln('  - ${formatLocalizationIssue(issue)}');
  }

  final changedIssues = _filterChanged(issues);
  if (changedIssues.isNotEmpty) {
    stderr.writeln();
    stderr.writeln('Unlocalized strings in changed files:');
    for (final file in changedIssues.keys) {
      stderr.writeln('  - $file (${changedIssues[file]!.length})');
      for (final issue in changedIssues[file]!) {
        stderr.writeln('    · ${issue.line}:${issue.column} — ${issue.description}');
      }
    }
  }

  exitCode = 1;
}

Map<String, List<LocalizationIssue>> _filterChanged(List<LocalizationIssue> issues) {
  final changed = _gitChangedFiles();
  if (changed.isEmpty) return const {};

  final byFile = <String, List<LocalizationIssue>>{};
  for (final issue in issues) {
    if (!changed.contains(issue.file)) continue;
    byFile.putIfAbsent(issue.file, () => []).add(issue);
  }
  return byFile;
}

Set<String> _gitChangedFiles() {
  try {
    final result = Process.runSync('git', ['status', '--porcelain']);
    if (result.exitCode != 0) return const {};
    return result.stdout.toString().split('\n').where((line) => line.length > 3).map((line) {
      var path = line.substring(3);
      if (path.contains(' -> ')) path = path.split(' -> ').last;
      if (path.startsWith('"') && path.endsWith('"')) path = path.substring(1, path.length - 1);
      return path;
    }).toSet();
  } on IOException {
    return const {};
  }
}
