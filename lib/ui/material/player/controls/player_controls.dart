import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../core/utils/audio_manager.dart';
import 'player_buttons.dart';

class PlayerControls extends StatelessWidget {
  final AudioManager audioManager;

  const PlayerControls({super.key, required this.audioManager});

  @override
  Widget build(BuildContext context) {
    final player = audioManager.player;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: StreamBuilder<PlayerState>(
        stream: player.playerStateStream,
        builder: (_, snapshot) {
          final playerState = snapshot.data;
          final playing = playerState?.playing ?? false;
          final colorScheme = Theme.of(context).colorScheme;

          return LayoutBuilder(
            builder: (_, constraints) {
              final size = constraints.maxWidth / 1.8;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: playing ? audioManager.pause : audioManager.play,
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(color: colorScheme.primary, shape: BoxShape.circle),
                      child: Icon(
                        playing ? Icons.pause : Icons.play_arrow,
                        size: size * 0.45,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: size * 0.05),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          CapsuleButton(
                            icon: Icons.skip_previous,
                            onPressed: audioManager.previous,
                            width: size * 0.35,
                            height: size * 0.7,
                          ),
                          SizedBox(width: size * 0.015),
                          CapsuleButton(
                            icon: Icons.skip_next,
                            onPressed: audioManager.next,
                            width: size * 0.35,
                            height: size * 0.7,
                          ),
                        ],
                      ),
                      SizedBox(height: size * 0.015),
                      Row(
                        children: [
                          BadgeButton(icon: Icons.shuffle, onPressed: () {}, size: size * 0.35),
                          SizedBox(width: size * 0.015),
                          CircleControlButton(icon: Icons.queue_music, onPressed: () {}, size: size * 0.35),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
