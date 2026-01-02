import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/deps/providers.dart';
import '../../domain/entity/album_entity.dart';
import '../../domain/entity/artist_entity.dart';
import '../../domain/entity/playlist_entity.dart';
import '../../domain/entity/song_entity.dart';
import '../../domain/providers.dart';

// --- UI State Providers ---
// Эти провайдеры управляют состоянием экрана. Они:
// 1. Проверяют разрешения через Core Service.
// 2. Запрашивают данные через Domain Repo.

final songsProvider = FutureProvider<List<SongEntity>>((ref) async {
  // 1. Проверка прав
  final permissionService = ref.watch(permissionServiceProvider);
  final bool hasPermission = await permissionService.checkAndRequestPermissions();

  if (!hasPermission) {
    // Можно вернуть пустой список или выбросить ошибку для обработки UI
    return [];
  }

  // 2. Получение данных
  final repo = ref.watch(musicRepoProvider);
  return repo.getSongs();
});

final artistsProvider = FutureProvider<List<ArtistEntity>>((ref) async {
  final permissionService = ref.watch(permissionServiceProvider);
  final bool hasPermission = await permissionService.checkAndRequestPermissions();

  if (!hasPermission) return [];

  final repo = ref.watch(musicRepoProvider);
  return repo.getArtists();
});

final albumsProvider = FutureProvider<List<AlbumEntity>>((ref) async {
  final permissionService = ref.watch(permissionServiceProvider);
  final bool hasPermission = await permissionService.checkAndRequestPermissions();

  if (!hasPermission) return [];

  final repo = ref.watch(musicRepoProvider);
  return repo.getAlbums();
});

final playlistsProvider = FutureProvider<List<PlaylistEntity>>((ref) async {
  final permissionService = ref.watch(permissionServiceProvider);
  final bool hasPermission = await permissionService.checkAndRequestPermissions();

  if (!hasPermission) return [];

  final repo = ref.watch(musicRepoProvider);
  return repo.getPlaylists();
});
