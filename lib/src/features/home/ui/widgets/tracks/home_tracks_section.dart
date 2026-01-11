import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/deps/providers.dart';
import '../../state/home_state.dart';
import 'tile_widget.dart';

class HomeTracksSection extends ConsumerWidget {
  const HomeTracksSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsAsync = ref.watch(songsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          data: (songs) {
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
                final song = songs[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TileWidget(
                    title: song.title,
                    subtitle: song.artist,
                    imageUrl: song.imageUrl ?? '',
                    onTap: () async {
                      final audioManager = ref.read(audioManagerProvider);
                      await audioManager.setPlaylist(
                        songs,
                        initialIndex: index,
                      );
                      await audioManager.play();
                      // Player screen will be accessible via MiniPlayer
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
      ],
    );
  }
}
