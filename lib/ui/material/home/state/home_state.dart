import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/deps/providers.dart';
import '../../../../model/album_model.dart';
import '../../../../model/artist_model.dart';
import '../../../../model/playlist_model.dart';
import '../../../../model/song_model.dart';
import '../../../../service/providers.dart';

final songsProvider = FutureProvider<List<SongModel>>((ref) async {
  final permissionManager = ref.watch(permissionManagerProvider);
  final bool hasPermission = await permissionManager.checkAndRequestPermissions();

  if (!hasPermission) {
    return [];
  }

  final service = ref.watch(mediaStoreServiceProvider);
  return service.getSongs();
});

final artistsProvider = FutureProvider<List<ArtistModel>>((ref) async {
  final permissionManager = ref.watch(permissionManagerProvider);
  final bool hasPermission = await permissionManager.checkAndRequestPermissions();

  if (!hasPermission) return [];

  final service = ref.watch(mediaStoreServiceProvider);
  return service.getArtists();
});

final albumsProvider = FutureProvider<List<AlbumModel>>((ref) async {
  final permissionManager = ref.watch(permissionManagerProvider);
  final bool hasPermission = await permissionManager.checkAndRequestPermissions();

  if (!hasPermission) return [];

  final service = ref.watch(mediaStoreServiceProvider);
  return service.getAlbums();
});

final playlistsProvider = FutureProvider<List<PlaylistModel>>((ref) async {
  final permissionManager = ref.watch(permissionManagerProvider);
  final bool hasPermission = await permissionManager.checkAndRequestPermissions();

  if (!hasPermission) return [];

  final service = ref.watch(mediaStoreServiceProvider);
  return service.getPlaylists();
});
