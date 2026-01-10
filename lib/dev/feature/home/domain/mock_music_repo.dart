import '../../../../src/features/home/domain/entity/album_entity.dart';
import '../../../../src/features/home/domain/entity/artist_entity.dart';
import '../../../../src/features/home/domain/entity/playlist_entity.dart';
import '../../../../src/features/home/domain/entity/song_entity.dart';
import '../../../../src/features/home/domain/repo/music_repo.dart';
import '../data/mock_data.dart';

class MockMusicRepo implements MusicRepo {
  @override
  Future<List<AlbumEntity>> getAlbums() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.albums;
  }

  @override
  Future<List<ArtistEntity>> getArtists() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.artists;
  }

  @override
  Future<List<PlaylistEntity>> getPlaylists() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.playlists;
  }

  @override
  Future<List<SongEntity>> getSongs() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.songs;
  }
}
