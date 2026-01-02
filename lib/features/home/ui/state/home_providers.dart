import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reson/core/deps/providers.dart';
import 'package:reson/features/home/domain/entity/song_entity.dart';

final songsProvider = FutureProvider<List<SongEntity>>((ref) async {
  final repo = ref.watch(songsRepoProvider);
  return repo.getSongs();
});
