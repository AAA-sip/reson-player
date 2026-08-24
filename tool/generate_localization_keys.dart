// Generates typed localization accessors from bundled English strings.
//
// Usage: dart run tool/generate_localization_keys.dart
// Output: lib/core/localization/strings.g.dart
//
// Usage in code:
//   Text(Strings.settings.title)

import 'dart:convert';
import 'dart:io';

import 'localization_codegen.dart';

void main() {
  final source = File(enJsonPath);
  if (!source.existsSync()) {
    stderr.writeln('Input file not found: $enJsonPath');
    exitCode = 1;
    return;
  }

  final json = jsonDecode(source.readAsStringSync()) as Map<String, dynamic>;
  final generated = generateStringsSource(json);

  final outFile = File(stringsDartPath);
  if (outFile.existsSync() && outFile.readAsStringSync() == generated) {
    stdout.writeln('$stringsDartPath is up to date');
    return;
  }
  outFile.writeAsStringSync(generated);
  stdout.writeln('Generated $stringsDartPath');
}
