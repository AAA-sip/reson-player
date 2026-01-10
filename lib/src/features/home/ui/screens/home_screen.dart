import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/deps/providers.dart';
import '../../../../core/utils/audio_manager.dart';
import '../../domain/entity/album_entity.dart';
import '../../domain/entity/artist_entity.dart';
import '../../domain/entity/playlist_entity.dart';
import '../../domain/entity/song_entity.dart';
import '../state/home_providers.dart';
import '../widgets/cart_widget.dart';
import '../widgets/circle_widget.dart';
import '../widgets/tile_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<AlbumEntity>> albumsAsync = ref.watch(albumsProvider);
    final AsyncValue<List<PlaylistEntity>> playlistsAsync = ref.watch(
      playlistsProvider,
    );
    final AsyncValue<List<ArtistEntity>> artistsAsync = ref.watch(
      artistsProvider,
    );
    final AsyncValue<List<SongEntity>> songsAsync = ref.watch(songsProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: const Text('Discover'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Albums & Playlists',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  ...albumsAsync.when(
                    data: (List<AlbumEntity> albums) => albums.map(
                      (AlbumEntity album) => Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: CartWidget(
                          title: album.title,
                          subtitle: album.artist,
                          imageUrl: album.imageUrl ?? '',
                        ),
                      ),
                    ),
                    error: (_, _) => [const Center(child: Text('Error'))],
                    loading: () => [
                      const Center(child: CircularProgressIndicator()),
                    ],
                  ),
                  ...playlistsAsync.when(
                    data: (List<PlaylistEntity> playlists) => playlists.map(
                      (PlaylistEntity playlist) => Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: CartWidget(
                          title: playlist.name,
                          subtitle: '${playlist.numberOfSongs} Songs',
                          imageUrl: playlist.imageUrl ?? '',
                        ),
                      ),
                    ),
                    error: (_, _) => [],
                    loading: () => [],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Artists',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 120,
              child: artistsAsync.when(
                data: (List<ArtistEntity> artists) {
                  if (artists.isEmpty) {
                    return const Center(child: Text('No artists found.'));
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: artists.length,
                    itemBuilder: (BuildContext context, int index) {
                      final ArtistEntity artist = artists[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: CircleWidget(
                          title: artist.name,
                          imageUrl: artist.imageUrl ?? '',
                        ),
                      );
                    },
                  );
                },
                error: (Object err, StackTrace stack) =>
                    Center(child: Text('Error: $err')),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Tracks',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            songsAsync.when(
              data: (List<SongEntity> songs) {
                if (songs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No songs found.'),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: songs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final SongEntity song = songs[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TileWidget(
                        title: song.title,
                        subtitle: song.artist,
                        imageUrl: song.imageUrl ?? '',
                        onTap: () async {
                          final AudioManager audioManager = ref.read(
                            audioManagerProvider,
                          );
                          await audioManager.setPlaylist(
                            songs,
                            initialIndex: index,
                          );
                          await audioManager.play();
                          if (context.mounted) {
                            context.push('/player');
                          }
                        },
                      ),
                    );
                  },
                );
              },
              error: (Object err, StackTrace stack) =>
                  Center(child: Text('Error: $err')),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
            const SizedBox(height: 80), // Bottom padding for FAB or content
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/player'),
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
