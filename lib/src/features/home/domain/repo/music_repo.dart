import '../../data/service/media_store_service.dart';
import '../entity/album_entity.dart';
import '../entity/artist_entity.dart';
import '../entity/playlist_entity.dart';
import '../entity/song_entity.dart';

abstract class MusicRepo {
  Future<List<SongEntity>> getSongs();
  Future<List<ArtistEntity>> getArtists();
  Future<List<AlbumEntity>> getAlbums();
  Future<List<PlaylistEntity>> getPlaylists();
}

class MusicRepoImpl implements MusicRepo {
  final MediaStoreService _mediaStoreService;

  MusicRepoImpl(this._mediaStoreService);

  @override
  Future<List<SongEntity>> getSongs() async {
    final models = await _mediaStoreService.getSongs();
    return models
        .map(
          (model) => SongEntity(
            id: model.id,
            title: model.title,
            artist: model.artist,
            uri: model.uri,
            duration: model.duration,
            imageUrl: model.imageUrl,
          ),
        )
        .toList();
  }

  @override
  Future<List<ArtistEntity>> getArtists() async {
    final models = await _mediaStoreService.getArtists();
    return models
        .map(
          (model) => ArtistEntity(
            id: model.id,
            name: model.name,
            numberOfTracks: model.numberOfTracks,
            numberOfAlbums: model.numberOfAlbums,
            imageUrl: model.imageUrl,
          ),
        )
        .toList();
  }

  @override
  Future<List<AlbumEntity>> getAlbums() async {
    final models = await _mediaStoreService.getAlbums();
    return models
        .map(
          (model) => AlbumEntity(
            id: model.id,
            title: model.title,
            artist: model.artist,
            numberOfSongs: model.numberOfSongs,
            imageUrl: model.imageUrl,
          ),
        )
        .toList();
  }

  @override
  Future<List<PlaylistEntity>> getPlaylists() async {
    final models = await _mediaStoreService.getPlaylists();
    return models
        .map(
          (model) => PlaylistEntity(
            id: model.id,
            name: model.name,
            numberOfSongs: model.numberOfSongs,
            imageUrl: model.imageUrl,
          ),
        )
        .toList();
  }
}
