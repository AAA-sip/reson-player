class SongEntity {
  final int id;
  final String title;
  final String artist;
  final String uri;
  final int duration;
  final String? imageUrl;

  SongEntity({
    required this.id,
    required this.title,
    required this.artist,
    required this.uri,
    required this.duration,
    this.imageUrl,
  });
}
