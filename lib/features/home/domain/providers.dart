// ignore_for_file: always_specify_types

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/service/media_store_service.dart';
import 'repo/music_repo.dart';

final mediaStoreServiceProvider = Provider<MediaStoreService>((ref) {
  return MediaStoreServiceImpl();
});

final musicRepoProvider = Provider<MusicRepo>((ref) {
  final MediaStoreService mediaStoreService = ref.watch(
    mediaStoreServiceProvider,
  );
  return MusicRepoImpl(mediaStoreService);
});
