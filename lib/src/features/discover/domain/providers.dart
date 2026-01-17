import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/service/media_store_service.dart';
import 'repo/music_repo.dart';

final mediaStoreServiceProvider = Provider<MediaStoreService>(
  (ref) => MediaStoreServiceImpl(),
);

final musicRepoProvider = Provider<MusicRepo>((ref) {
  final mediaStoreService = ref.read(mediaStoreServiceProvider);
  return MusicRepoImpl(mediaStoreService);
});
