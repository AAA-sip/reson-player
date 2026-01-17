class AlbumEntity {
  final int id;
  final String title;
  final String artist;
  final int numberOfSongs;
  final String? imageUrl;

  AlbumEntity({
    required this.id,
    required this.title,
    required this.artist,
    required this.numberOfSongs,
    this.imageUrl,
  });
}
