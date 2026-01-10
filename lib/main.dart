import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'dev/feature/home/domain/mock_music_repo.dart';
import 'src/features/home/domain/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// if it grows, put it in another file and split it
  runApp(
    ProviderScope(
      overrides: [musicRepoProvider.overrideWith((ref) => MockMusicRepo())],
      child: const ResonApp(),
    ),
  );
}
