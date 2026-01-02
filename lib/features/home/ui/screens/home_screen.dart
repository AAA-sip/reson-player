import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/deps/providers.dart';
import '../../domain/providers.dart';
import '../state/home_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reson Music'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Music'),
              Tab(text: 'Artists'),
              Tab(text: 'Playlists'),
              Tab(text: 'Albums'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _MusicList(),
            _ArtistList(),
            _PlaylistList(),
            _AlbumList(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push('/player'),
          child: const Icon(Icons.play_arrow),
        ),
      ),
    );
  }
}

class _MusicList extends ConsumerWidget {
  const _MusicList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsAsync = ref.watch(songsProvider);

    return songsAsync.when(
      data: (songs) {
        if (songs.isEmpty) {
          return const Center(child: Text('No songs found on device.'));
        }
        return ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context, index) {
            final song = songs[index];
            return ListTile(
              leading: const Icon(Icons.music_note),
              title: Text(
                song.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                song.artist,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () async {
                final audioService = ref.read(audioServiceProvider);
                await audioService.setPlaylist(songs, initialIndex: index);
                await audioService.play();
                if (context.mounted) {
                  context.push('/player');
                }
              },
            );
          },
        );
      },
      error: (err, stack) => Center(child: Text('Error: $err')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class _ArtistList extends ConsumerWidget {
  const _ArtistList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artistsAsync = ref.watch(artistsProvider);

    return artistsAsync.when(
      data: (artists) {
        if (artists.isEmpty) {
          return const Center(child: Text('No artists found.'));
        }
        return ListView.builder(
          itemCount: artists.length,
          itemBuilder: (context, index) {
            final artist = artists[index];
            return ListTile(
              leading: const Icon(Icons.person),
              title: Text(artist.name),
              subtitle: Text(
                '${artist.numberOfTracks} Tracks • ${artist.numberOfAlbums} Albums',
              ),
              onTap: () {
                // TODO: Navigate to artist details
              },
            );
          },
        );
      },
      error: (err, stack) => Center(child: Text('Error: $err')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class _PlaylistList extends ConsumerWidget {
  const _PlaylistList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistsAsync = ref.watch(playlistsProvider);

    return playlistsAsync.when(
      data: (playlists) {
        if (playlists.isEmpty) {
          return const Center(child: Text('No playlists found.'));
        }
        return ListView.builder(
          itemCount: playlists.length,
          itemBuilder: (context, index) {
            final playlist = playlists[index];
            return ListTile(
              leading: const Icon(Icons.playlist_play),
              title: Text(playlist.name),
              subtitle: Text('${playlist.numberOfSongs} Songs'),
              onTap: () {
                // TODO: Navigate to playlist details
              },
            );
          },
        );
      },
      error: (err, stack) => Center(child: Text('Error: $err')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class _AlbumList extends ConsumerWidget {
  const _AlbumList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumsAsync = ref.watch(albumsProvider);

    return albumsAsync.when(
      data: (albums) {
        if (albums.isEmpty) {
          return const Center(child: Text('No albums found.'));
        }
        return ListView.builder(
          itemCount: albums.length,
          itemBuilder: (context, index) {
            final album = albums[index];
            return ListTile(
              leading: const Icon(Icons.album),
              title: Text(album.title),
              subtitle: Text(album.artist),
              onTap: () {
                // TODO: Navigate to album details
              },
            );
          },
        );
      },
      error: (err, stack) => Center(child: Text('Error: $err')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
