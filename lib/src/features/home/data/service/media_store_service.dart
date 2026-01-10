import 'package:on_audio_query/on_audio_query.dart' as audio_query;
import '../model/album_model.dart';
import '../model/artist_model.dart';
import '../model/playlist_model.dart';
import '../model/song_model.dart';

abstract class MediaStoreService {
  Future<List<SongModel>> getSongs();
  Future<List<ArtistModel>> getArtists();
  Future<List<AlbumModel>> getAlbums();
  Future<List<PlaylistModel>> getPlaylists();
}

class MediaStoreServiceImpl implements MediaStoreService {
  final audio_query.OnAudioQuery _audioQuery;

  MediaStoreServiceImpl({audio_query.OnAudioQuery? audioQuery})
    : _audioQuery = audioQuery ?? audio_query.OnAudioQuery();

  @override
  Future<List<SongModel>> getSongs() async {
    final songs = await _audioQuery.querySongs(
      sortType: audio_query.SongSortType.DATE_ADDED,
      orderType: audio_query.OrderType.DESC_OR_GREATER,
      uriType: audio_query.UriType.EXTERNAL,
      ignoreCase: true,
    );

    return songs.map((song) {
      return SongModel(
        id: song.id,
        title: song.title,
        artist: song.artist ?? 'Unknown Artist',
        uri: song.data,
        duration: song.duration ?? 0,
        imageUrl: null, // Model has nullable imageUrl
      );
    }).toList();
  }

  @override
  Future<List<ArtistModel>> getArtists() async {
    final artists = await _audioQuery.queryArtists(
      sortType: audio_query.ArtistSortType.ARTIST,
      orderType: audio_query.OrderType.ASC_OR_SMALLER,
      uriType: audio_query.UriType.EXTERNAL,
      ignoreCase: true,
    );

    return artists.map((artist) {
      return ArtistModel(
        id: artist.id,
        name: artist.artist,
        numberOfTracks: artist.numberOfTracks ?? 0,
        numberOfAlbums: artist.numberOfAlbums ?? 0,
        imageUrl: null,
      );
    }).toList();
  }

  @override
  Future<List<AlbumModel>> getAlbums() async {
    final albums = await _audioQuery.queryAlbums(
      sortType: audio_query.AlbumSortType.ALBUM,
      orderType: audio_query.OrderType.ASC_OR_SMALLER,
      uriType: audio_query.UriType.EXTERNAL,
      ignoreCase: true,
    );

    return albums.map((album) {
      return AlbumModel(
        id: album.id,
        title: album.album,
        artist: album.artist ?? 'Unknown Artist',
        numberOfSongs: album.numOfSongs,
        imageUrl: null,
      );
    }).toList();
  }

  @override
  Future<List<PlaylistModel>> getPlaylists() async {
    final playlists = await _audioQuery.queryPlaylists(
      sortType: audio_query.PlaylistSortType.PLAYLIST,
      orderType: audio_query.OrderType.ASC_OR_SMALLER,
      uriType: audio_query.UriType.EXTERNAL,
      ignoreCase: true,
    );

    return playlists.map((playlist) {
      return PlaylistModel(
        id: playlist.id,
        name: playlist.playlist,
        numberOfSongs: playlist.numOfSongs,
        imageUrl: null,
      );
    }).toList();
  }
}
