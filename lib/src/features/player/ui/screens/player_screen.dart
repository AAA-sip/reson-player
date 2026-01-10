import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../core/deps/providers.dart';
import '../../../home/domain/entity/song_entity.dart';

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioManager = ref.watch(audioManagerProvider);
    final player = audioManager.player;

    return Scaffold(
      appBar: AppBar(title: const Text('Now Playing')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Song Info
            StreamBuilder<SequenceState?>(
              stream: player.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state?.currentSource == null) {
                  return const Column(
                    children: [
                      Icon(Icons.music_note, size: 100, color: Colors.grey),
                      SizedBox(height: 20),
                      Text('No song playing', style: TextStyle(fontSize: 24)),
                    ],
                  );
                }
                final song = state!.currentSource!.tag as SongEntity;
                return Column(
                  children: [
                    const Icon(Icons.music_note, size: 100),
                    const SizedBox(height: 20),
                    Text(
                      song.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      song.artist,
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 40),

            // Seek Bar
            StreamBuilder<Duration>(
              stream: player.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                return StreamBuilder<Duration?>(
                  stream: player.durationStream,
                  builder: (context, snapshot) {
                    final duration = snapshot.data ?? Duration.zero;
                    return Column(
                      children: [
                        Slider(
                          value: position.inMilliseconds.toDouble().clamp(
                            0,
                            duration.inMilliseconds.toDouble(),
                          ),
                          max: duration.inMilliseconds.toDouble(),
                          onChanged: (value) {
                            audioManager.seek(
                              Duration(milliseconds: value.toInt()),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_formatDuration(position)),
                              Text(_formatDuration(duration)),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 40),

            // Controls
            StreamBuilder<PlayerState>(
              stream: player.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;

                if (processingState == ProcessingState.loading ||
                    processingState == ProcessingState.buffering) {
                  return const CircularProgressIndicator();
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 48,
                      icon: const Icon(Icons.skip_previous),
                      onPressed: player.hasPrevious
                          ? audioManager.previous
                          : null,
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      iconSize: 64,
                      icon: Icon(
                        playing == true
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                      ),
                      onPressed: playing == true
                          ? audioManager.pause
                          : audioManager.play,
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      iconSize: 48,
                      icon: const Icon(Icons.skip_next),
                      onPressed: player.hasNext ? audioManager.next : null,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return '--:--';
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
