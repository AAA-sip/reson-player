import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/deps/providers.dart';
import '../../domain/entity/album_entity.dart';
import '../../domain/entity/artist_entity.dart';
import '../../domain/entity/playlist_entity.dart';
import '../../domain/entity/song_entity.dart';
import '../../domain/providers.dart';

final songsProvider = FutureProvider<List<SongEntity>>((ref) async {
  final permissionManager = ref.watch(permissionManagerProvider);
  final bool hasPermission = await permissionManager
      .checkAndRequestPermissions();

  if (!hasPermission) {
    return [];
  }

  final repo = ref.watch(musicRepoProvider);
  return repo.getSongs();
});

final artistsProvider = FutureProvider<List<ArtistEntity>>((ref) async {
  final permissionManager = ref.watch(permissionManagerProvider);
  final bool hasPermission = await permissionManager
      .checkAndRequestPermissions();

  if (!hasPermission) return [];

  final repo = ref.watch(musicRepoProvider);
  return repo.getArtists();
});

final albumsProvider = FutureProvider<List<AlbumEntity>>((ref) async {
  final permissionManager = ref.watch(permissionManagerProvider);
  final bool hasPermission = await permissionManager
      .checkAndRequestPermissions();

  if (!hasPermission) return [];

  final repo = ref.watch(musicRepoProvider);
  return repo.getAlbums();
});

final playlistsProvider = FutureProvider<List<PlaylistEntity>>((ref) async {
  final permissionManager = ref.watch(permissionManagerProvider);
  final bool hasPermission = await permissionManager
      .checkAndRequestPermissions();

  if (!hasPermission) return [];

  final repo = ref.watch(musicRepoProvider);
  return repo.getPlaylists();
});
