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
    return await _mediaStoreService.getSongs();
  }

  @override
  Future<List<ArtistEntity>> getArtists() async {
    return await _mediaStoreService.getArtists();
  }

  @override
  Future<List<AlbumEntity>> getAlbums() async {
    return await _mediaStoreService.getAlbums();
  }

  @override
  Future<List<PlaylistEntity>> getPlaylists() async {
    return await _mediaStoreService.getPlaylists();
  }
}
