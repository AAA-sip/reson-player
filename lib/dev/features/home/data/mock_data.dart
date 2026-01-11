import '../../../../src/features/home/domain/entity/album_entity.dart';
import '../../../../src/features/home/domain/entity/artist_entity.dart';
import '../../../../src/features/home/domain/entity/playlist_entity.dart';
import '../../../../src/features/home/domain/entity/song_entity.dart';

class MockData {
  static final List<SongEntity> songs = [
    SongEntity(
      id: 1,
      title: 'Midnight City',
      artist: 'M83',
      uri: 'content://media/external/audio/media/1',
      duration: 243000,
      imageUrl: 'https://picsum.photos/seed/1/200',
    ),
    SongEntity(
      id: 2,
      title: 'Starboy',
      artist: 'The Weeknd',
      uri: 'content://media/external/audio/media/2',
      duration: 230000,
      imageUrl: 'https://picsum.photos/seed/2/200',
    ),
    SongEntity(
      id: 3,
      title: 'Get Lucky',
      artist: 'Daft Punk',
      uri: 'content://media/external/audio/media/3',
      duration: 248000,
      imageUrl: 'https://picsum.photos/seed/3/200',
    ),
    SongEntity(
      id: 4,
      title: 'Shape of You',
      artist: 'Ed Sheeran',
      uri: 'content://media/external/audio/media/4',
      duration: 233000,
      imageUrl: 'https://picsum.photos/seed/4/200',
    ),
    SongEntity(
      id: 5,
      title: 'Blinding Lights',
      artist: 'The Weeknd',
      uri: 'content://media/external/audio/media/5',
      duration: 200000,
      imageUrl: 'https://picsum.photos/seed/5/200',
    ),
  ];

  static final List<AlbumEntity> albums = [
    AlbumEntity(
      id: 1,
      title: 'Hurry Up, We\'re Dreaming',
      artist: 'M83',
      numberOfSongs: 22,
      imageUrl: 'https://picsum.photos/seed/album1/200',
    ),
    AlbumEntity(
      id: 2,
      title: 'Starboy',
      artist: 'The Weeknd',
      numberOfSongs: 18,
      imageUrl: 'https://picsum.photos/seed/album2/200',
    ),
    AlbumEntity(
      id: 3,
      title: 'Random Access Memories',
      artist: 'Daft Punk',
      numberOfSongs: 13,
      imageUrl: 'https://picsum.photos/seed/album3/200',
    ),
    AlbumEntity(
      id: 4,
      title: 'Divide',
      artist: 'Ed Sheeran',
      numberOfSongs: 16,
      imageUrl: 'https://picsum.photos/seed/album4/200',
    ),
    AlbumEntity(
      id: 5,
      title: 'After Hours',
      artist: 'The Weeknd',
      numberOfSongs: 14,
      imageUrl: 'https://picsum.photos/seed/album5/200',
    ),
  ];

  static final List<ArtistEntity> artists = [
    ArtistEntity(
      id: 1,
      name: 'M83',
      numberOfTracks: 50,
      numberOfAlbums: 6,
      imageUrl: 'https://picsum.photos/seed/artist1/200',
    ),
    ArtistEntity(
      id: 2,
      name: 'The Weeknd',
      numberOfTracks: 80,
      numberOfAlbums: 5,
      imageUrl: 'https://picsum.photos/seed/artist2/200',
    ),
    ArtistEntity(
      id: 3,
      name: 'Daft Punk',
      numberOfTracks: 40,
      numberOfAlbums: 4,
      imageUrl: 'https://picsum.photos/seed/artist3/200',
    ),
    ArtistEntity(
      id: 4,
      name: 'Ed Sheeran',
      numberOfTracks: 60,
      numberOfAlbums: 5,
      imageUrl: 'https://picsum.photos/seed/artist4/200',
    ),
  ];

  static final List<PlaylistEntity> playlists = [
    PlaylistEntity(
      id: 1,
      name: 'Favorites',
      numberOfSongs: 25,
      imageUrl: 'https://picsum.photos/seed/playlist1/200',
    ),
    PlaylistEntity(
      id: 2,
      name: 'Chill Vibes',
      numberOfSongs: 40,
      imageUrl: 'https://picsum.photos/seed/playlist2/200',
    ),
    PlaylistEntity(
      id: 3,
      name: 'Workout Mix',
      numberOfSongs: 30,
      imageUrl: 'https://picsum.photos/seed/playlist3/200',
    ),
    PlaylistEntity(
      id: 4,
      name: 'Road Trip',
      numberOfSongs: 50,
      imageUrl: 'https://picsum.photos/seed/playlist4/200',
    ),
  ];
}
