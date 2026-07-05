import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../../../core/deps/providers.dart';
import '../../../core/theme/provider/theme_provider.dart';
import '../../../core/theme/theme_generator.dart';
import '../../../model/song_model.dart';
import 'player_artwork.dart';
import 'player_controls.dart';
import 'waveform_progress_bar.dart';

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioManager = ref.watch(audioManagerProvider);
    final themeConfig = ref.watch(themeControllerProvider);
    final player = audioManager.player;

    // Always force dark theme for the player
    final darkTheme = generateTheme(brightness: Brightness.dark, config: themeConfig);

    return Theme(
      data: darkTheme,
      child: Scaffold(
        body: StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) {
            final state = snapshot.data;
            if (state?.currentSource == null) {
              return const Center(child: Text('No song playing'));
            }
            final mediaItem = state!.currentSource!.tag as MediaItem;
            final song = mediaItem.extras!['song'] as SongModel;

            return Column(
              children: [
                // Top Image Section
                Expanded(flex: 14, child: PlayerArtwork(song: song)),

                // Progress Bar Section
                StreamBuilder<Duration>(
                  stream: player.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    return StreamBuilder<Duration?>(
                      stream: player.durationStream,
                      builder: (context, snapshot) {
                        final duration = snapshot.data ?? Duration.zero;
                        return StreamBuilder<PlayerState>(
                          stream: player.playerStateStream,
                          builder: (context, playerSnapshot) {
                            final isPlaying = playerSnapshot.data?.playing ?? false;
                            return WaveformProgressBar(
                              position: position,
                              duration: duration,
                              isPlaying: isPlaying,
                              onChanged: (newPosition) {
                                audioManager.seek(newPosition);
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),

                // Controls Section
                Expanded(flex: 7, child: PlayerControls(audioManager: audioManager)),
              ],
            );
          },
        ),
      ),
    );
  }
}
