class ArtistModel {
  final int id;
  final String name;
  final int numberOfTracks;
  final int numberOfAlbums;
  final String? imageUrl;

  ArtistModel({
    required this.id,
    required this.name,
    required this.numberOfTracks,
    required this.numberOfAlbums,
    this.imageUrl,
  });
}
