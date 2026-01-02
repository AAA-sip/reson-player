import 'package:on_audio_query/on_audio_query.dart';

import '../../domain/entity/album_entity.dart';
import '../../domain/entity/artist_entity.dart';
import '../../domain/entity/playlist_entity.dart';
import '../../domain/entity/song_entity.dart';

abstract class MediaStoreService {
  Future<List<SongEntity>> getSongs();
  Future<List<ArtistEntity>> getArtists();
  Future<List<AlbumEntity>> getAlbums();
  Future<List<PlaylistEntity>> getPlaylists();
}

class MediaStoreServiceImpl implements MediaStoreService {
  final OnAudioQuery _audioQuery;

  MediaStoreServiceImpl({OnAudioQuery? audioQuery})
    : _audioQuery = audioQuery ?? OnAudioQuery();

  @override
  Future<List<SongEntity>> getSongs() async {
    final List<SongModel> songs = await _audioQuery.querySongs(
      sortType: SongSortType.DATE_ADDED,
      orderType: OrderType.DESC_OR_GREATER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    return songs.map((SongModel song) {
      return SongEntity(
        id: song.id,
        title: song.title,
        artist: song.artist ?? 'Unknown Artist',
        uri: song.data,
        duration: song.duration ?? 0,
      );
    }).toList();
  }

  @override
  Future<List<ArtistEntity>> getArtists() async {
    final List<ArtistModel> artists = await _audioQuery.queryArtists(
      sortType: ArtistSortType.ARTIST,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    return artists.map((ArtistModel artist) {
      return ArtistEntity(
        id: artist.id,
        name: artist.artist,
        numberOfTracks: artist.numberOfTracks ?? 0,
        numberOfAlbums: artist.numberOfAlbums ?? 0,
      );
    }).toList();
  }

  @override
  Future<List<AlbumEntity>> getAlbums() async {
    final List<AlbumModel> albums = await _audioQuery.queryAlbums(
      sortType: AlbumSortType.ALBUM,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    return albums.map((AlbumModel album) {
      return AlbumEntity(
        id: album.id,
        title: album.album,
        artist: album.artist ?? 'Unknown Artist',
        numberOfSongs: album.numOfSongs,
      );
    }).toList();
  }

  @override
  Future<List<PlaylistEntity>> getPlaylists() async {
    final List<PlaylistModel> playlists = await _audioQuery.queryPlaylists(
      sortType: PlaylistSortType.PLAYLIST,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    return playlists.map((PlaylistModel playlist) {
      return PlaylistEntity(
        id: playlist.id,
        name: playlist.playlist,
        numberOfSongs: playlist.numOfSongs,
      );
    }).toList();
  }
}
