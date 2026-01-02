import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reson/core/service/audio_service.dart';
import 'package:reson/features/home/data/repo/songs_repo_impl.dart';
import 'package:reson/features/home/domain/repo/songs_repo.dart';

final audioServiceProvider = Provider<AudioService>((ref) {
  return AudioService();
});

final songsRepoProvider = Provider<SongsRepo>((ref) {
  return SongsRepoImpl();
});
