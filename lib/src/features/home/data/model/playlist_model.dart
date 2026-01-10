class PlaylistModel {
  final int id;
  final String name;
  final int numberOfSongs;
  final String? imageUrl;

  PlaylistModel({
    required this.id,
    required this.name,
    required this.numberOfSongs,
    this.imageUrl,
  });
}
