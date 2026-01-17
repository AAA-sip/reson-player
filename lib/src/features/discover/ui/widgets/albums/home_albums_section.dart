import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/home_state.dart';
import 'cart_widget.dart';

class HomeAlbumsSection extends ConsumerWidget {
  const HomeAlbumsSection({super.key});

  @override
  Widget build(context, ref) {
    final albumsAsync = ref.watch(albumsProvider);
    final playlistsAsync = ref.watch(playlistsProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Albums & Playlists',
            style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              ...albumsAsync.when(
                data: (albums) => albums.map(
                  (album) => Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: CartWidget(title: album.title, subtitle: album.artist, imageUrl: album.imageUrl ?? ''),
                  ),
                ),
                error: (_, _) => [const Center(child: Text('Error'))],
                loading: () => [const Center(child: CircularProgressIndicator())],
              ),
              ...playlistsAsync.when(
                data: (playlists) => playlists.map(
                  (playlist) => Padding(
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
      ],
    );
  }
}
