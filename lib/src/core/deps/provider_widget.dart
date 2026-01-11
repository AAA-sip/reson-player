// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../dev/features/home/domain/mock_music_repo.dart';
import '../../features/home/domain/providers.dart';

class ProviderWidget extends StatelessWidget {
  const ProviderWidget({super.key, required this.app});

  final Widget app;

  @override
  Widget build(_) =>
      //
      ProviderScope(
        // overrides: [musicRepoProvider.overrideWith((_) => MockMusicRepo())],
        child: app,
      );
}
