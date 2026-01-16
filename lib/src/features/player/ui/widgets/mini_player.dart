import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../../../../core/deps/providers.dart';
import '../../../home/domain/entity/song_entity.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioManager = ref.watch(audioManagerProvider);
    final player = audioManager.player;

    return StreamBuilder<SequenceState?>(
      stream: player.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state?.currentSource == null) return const SizedBox.shrink();

        final mediaItem = state!.currentSource!.tag as MediaItem;
        final song = mediaItem.extras!['song'] as SongEntity;

        return GestureDetector(
          onTap: () => context.push('/player'),
          child: Container(
            height: 64, // Fixed height for consistency
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16), // Floating margin
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Column(
              children: [
                // Progress Bar at the top (optional visual flair)
                StreamBuilder<Duration>(
                  stream: player.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    final duration = player.duration ?? Duration.zero;
                    if (duration.inMilliseconds == 0) {
                      return const SizedBox(height: 2);
                    }
                    return LinearProgressIndicator(
                      value: position.inMilliseconds / duration.inMilliseconds,
                      minHeight: 2,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        // Artwork / Icon
                        _buildArtwork(context, song),
                        const SizedBox(width: 12),
                        // Title & Artist
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                song.title,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                song.artist,
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        // Play/Pause Button
                        StreamBuilder<PlayerState>(
                          stream: player.playerStateStream,
                          builder: (context, snapshot) {
                            final playerState = snapshot.data;
                            final playing = playerState?.playing;
                            return IconButton(
                              icon: Icon(
                                playing == true ? Icons.pause : Icons.play_arrow,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              onPressed: playing == true
                                  ? audioManager.pause
                                  : audioManager.play,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      },
    );
  }

  Widget _buildArtwork(BuildContext context, SongEntity song) {
    // Placeholder for artwork. In a real app, use QueryArtworkWidget or similar.
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(
        Icons.music_note,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }
}
