import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/deps/providers.dart';
import '../../../../core/localization/strings.g.dart';
import '../state/home_state.dart';
import 'tracks/tile_widget.dart';

class TracksWidget extends ConsumerWidget {
  const TracksWidget({super.key});

  @override
  Widget build(context, ref) {
    final songsAsync = ref.watch(songsProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            Strings.home.sections.tracks,
            style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
          ),
        ),
        songsAsync.when(
          data: (songs) {
            if (songs.isEmpty) {
              return Padding(padding: const EdgeInsets.all(16.0), child: Text(Strings.home.empty.songs));
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: songs.length,
              itemBuilder: (BuildContext context, int index) {
                final song = songs[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TileWidget(
                    title: song.title,
                    subtitle: song.artist,
                    imageUrl: song.imageUrl ?? '',
                    onTap: () async {
                      final audioManager = ref.read(audioManagerProvider);
                      await audioManager.setPlaylist(songs, initialIndex: index);
                      await audioManager.play();
                      // Player screen will be accessible via MiniPlayer
                    },
                  ),
                );
              },
            );
          },
          error: (Object err, StackTrace stack) => Center(child: Text('${Strings.common.error}: $err')),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}
