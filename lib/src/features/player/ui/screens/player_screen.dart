import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../../../core/deps/providers.dart';
import '../../../home/domain/entity/song_entity.dart';

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioManager = ref.watch(audioManagerProvider);
    final player = audioManager.player;

    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<SequenceState?>(
        stream: player.sequenceStateStream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state?.currentSource == null) {
            return const Center(child: Text('No song playing'));
          }
          final mediaItem = state!.currentSource!.tag as MediaItem;
          final song = mediaItem.extras!['song'] as SongEntity;

          return Column(
            children: [
              // Top Image Section
              Expanded(
                flex: 13,
                child: Stack(
                  children: [
                    // Album Art
                    Positioned.fill(
                      child: QueryArtworkWidget(
                        id: song.id,
                        type: ArtworkType.AUDIO,
                        artworkHeight: double.infinity,
                        artworkWidth: double.infinity,
                        artworkFit: BoxFit.cover,
                        nullArtworkWidget: Container(
                          color: Colors.grey[900],
                          child: const Icon(Icons.music_note, size: 100, color: Colors.white),
                        ),
                      ),
                    ),
                    // Gradient Overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.2),
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withOpacity(0.9),
                            ],
                            stops: const [0.0, 0.2, 0.6, 1.0],
                          ),
                        ),
                      ),
                    ),
                    // Back Button
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 10,
                      left: 20,
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.3),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    // Share Button
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 10,
                      right: 20,
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.3),
                        child: IconButton(
                          icon: const Icon(Icons.share, color: Colors.white),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    // Song Info and Add Button
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  song.title.toUpperCase(),
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 42,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -2,
                                    height: 1.0,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  song.artist,
                                  style: GoogleFonts.inter(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1.5),
                            ),
                            child: const Icon(Icons.add, color: Colors.white, size: 32),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

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
              Expanded(
                flex: 7,
                child: Container(
                  width: double.infinity,
                  color: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: StreamBuilder<PlayerState>(
                    stream: player.playerStateStream,
                    builder: (context, snapshot) {
                      final playerState = snapshot.data;
                      final playing = playerState?.playing ?? false;

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final size = constraints.maxHeight * 0.8;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Play/Pause Large Circle
                              GestureDetector(
                                onTap: playing ? audioManager.pause : audioManager.play,
                                child: Container(
                                  width: size,
                                  height: size,
                                  decoration: const BoxDecoration(color: Color(0xFFD0E16C), shape: BoxShape.circle),
                                  child: Icon(
                                    playing ? Icons.pause : Icons.play_arrow,
                                    size: size * 0.45,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              // Previous/Next Capsules
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _CapsuleButton(
                                    icon: Icons.skip_previous,
                                    onPressed: audioManager.previous,
                                    height: size * 0.35,
                                    width: size * 0.5,
                                  ),
                                  const SizedBox(height: 12),
                                  _CapsuleButton(
                                    icon: Icons.skip_next,
                                    onPressed: audioManager.next,
                                    height: size * 0.35,
                                    width: size * 0.5,
                                  ),
                                ],
                              ),
                              // Shuffle and Queue
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _BadgeButton(icon: Icons.shuffle, onPressed: () {}, size: size * 0.45),
                                  const SizedBox(height: 12),
                                  _CircleControlButton(icon: Icons.queue_music, onPressed: () {}, size: size * 0.45),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}

// --- CONFIGURATION ---
// You can change these values to customize the look and feel!
class WaveConfig {
  static const double waveHeight = 5.0; // How tall the wave is
  static const double waveFrequency = 0.2; // How "tight" the curves are
  static const double gap = 6.0; // Space between wave and cursor
  static const double cursorHeight = 24.0; // Height of the vertical bar
  static const double strokeWidth = 2.0; // Thickness of the lines

  // Animation Settings
  static const Duration shrinkDuration = Duration(milliseconds: 150); // How fast it flattens when paused
  static const Duration waveSpeedDuration = Duration(seconds: 2); // How fast one wave cycle moves
}

// ---------------------
class WaveformProgressBar extends StatefulWidget {
  final Duration position;
  final Duration duration;
  final bool isPlaying;
  final ValueChanged<Duration> onChanged;

  const WaveformProgressBar({
    super.key,
    required this.position,
    required this.duration,
    required this.isPlaying,
    required this.onChanged,
  });

  @override
  State<WaveformProgressBar> createState() => _WaveformProgressBarState();
}

class _WaveformProgressBarState extends State<WaveformProgressBar> with TickerProviderStateMixin {
  late AnimationController _phaseController; // Контроллер движения (прокрутки)
  late AnimationController _amplitudeController; // Контроллер высоты (сглаживания)

  @override
  void initState() {
    super.initState();

    // 1. Анимация движения (зациклена, когда играет)
    _phaseController = AnimationController(vsync: this, duration: WaveConfig.waveSpeedDuration);

    // 2. Анимация высоты (плавно меняется от 0.0 до 1.0)
    _amplitudeController = AnimationController(
      vsync: this,
      duration: WaveConfig.shrinkDuration, // Используем настройку скорости
      value: widget.isPlaying ? 1.0 : 0.0,
    );

    if (widget.isPlaying) {
      _phaseController.repeat();
    }
  }

  @override
  void didUpdateWidget(WaveformProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        // ИГРАЕТ: Начинаем движение и плавно увеличиваем высоту до 1.0
        _phaseController.repeat();
        _amplitudeController.forward();
      } else {
        // ПАУЗА: Плавно уменьшаем высоту до 0.0 (линия), потом останавливаем движение
        _amplitudeController.reverse().then((_) {
          if (!mounted) return;
          _phaseController.stop();
        });
      }
    }
  }

  @override
  void dispose() {
    _phaseController.dispose();
    _amplitudeController.dispose();
    super.dispose();
  }

  void _seek(BuildContext context, Offset localPosition) {
    final box = context.findRenderObject() as RenderBox;
    // Корректируем область нажатия с учетом padding
    final x = localPosition.dx - 20;
    final width = box.size.width - 40;

    final newProgress = (x / width).clamp(0.0, 1.0);
    widget.onChanged(Duration(milliseconds: (newProgress * widget.duration.inMilliseconds).toInt()));
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.duration.inMilliseconds > 0
        ? widget.position.inMilliseconds / widget.duration.inMilliseconds
        : 0.0;

    return GestureDetector(
      onHorizontalDragUpdate: (details) => _seek(context, details.localPosition),
      onTapDown: (details) => _seek(context, details.localPosition),
      child: Container(
        width: double.infinity,
        height: 60,
        color: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: AnimatedBuilder(
          animation: Listenable.merge([_phaseController, _amplitudeController]),
          builder: (context, child) {
            return CustomPaint(
              painter: _ProgressBarPainter(
                progress: progress,
                phaseValue: _phaseController.value,
                amplitudeValue: _amplitudeController.value,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProgressBarPainter extends CustomPainter {
  final double progress;
  final double phaseValue; // 0.0 - 1.0 (Движение)
  final double amplitudeValue; // 0.0 - 1.0 (Множитель высоты)

  _ProgressBarPainter({required this.progress, required this.phaseValue, required this.amplitudeValue});

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final thumbX = size.width * progress;

    // Вычисляем динамические значения
    final currentAmplitude = WaveConfig.waveHeight * amplitudeValue;
    final waveShift = phaseValue * 2 * pi;
    // Точка, где заканчивается волна (позиция курсора минус отступ)
    final endActiveX = thumbX - WaveConfig.gap;

    // --- КИСТИ (PAINTS) ---
    final activePaint = Paint()
      ..color = const Color(0xFFD0E16C)
      ..strokeWidth = WaveConfig.strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final inactivePaint = Paint()
      ..color = const Color(0xFFD0E16C).withOpacity(0.3)
      ..strokeWidth = WaveConfig.strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final thumbPaint = Paint()
      ..color = const Color(0xFFD0E16C)
      ..strokeWidth = WaveConfig.strokeWidth
      ..strokeCap = StrokeCap.round;

    // 1. РИСУЕМ АКТИВНУЮ ВОЛНУ (Слева)
    // ИСПРАВЛЕНИЕ: Рисуем ТОЛЬКО если есть место для волны (endActiveX > 0).
    // Это полностью убирает "хвостик" в начале.
    // if (endActiveX > 0) {
    //   final activePath = Path();
    //   activePath.moveTo(0, centerY); // Всегда начинаем с 0

    //   // Цикл от 0 до точки перед отступом
    //   for (double x = 0; x <= endActiveX; x += 1) {
    //     final y =
    //         centerY +
    //         currentAmplitude * sin(x * WaveConfig.waveFrequency + waveShift);
    //     activePath.lineTo(x, y);
    //   }
    //   canvas.drawPath(activePath, activePaint);
    // }

    if (endActiveX > 0) {
      final activePath = Path();

      // первая точка — уже по синусу
      final y0 = centerY + currentAmplitude * sin(0 * WaveConfig.waveFrequency + waveShift);
      activePath.moveTo(0, y0);

      for (double x = 1; x <= endActiveX; x += 1) {
        final y = centerY + currentAmplitude * sin(x * WaveConfig.waveFrequency + waveShift);
        activePath.lineTo(x, y);
      }

      canvas.drawPath(activePath, activePaint);
    }

    // 2. РИСУЕМ НЕАКТИВНУЮ ЛИНИЮ (Справа)
    // Начинается после отступа
    final startInactiveX = thumbX + WaveConfig.gap;
    if (startInactiveX < size.width) {
      canvas.drawLine(Offset(startInactiveX, centerY), Offset(size.width, centerY), inactivePaint);
    }

    // 3. РИСУЕМ ИНДИКАТОР (Вертикальная линия)
    canvas.drawLine(
      Offset(thumbX, centerY - (WaveConfig.cursorHeight / 2)),
      Offset(thumbX, centerY + (WaveConfig.cursorHeight / 2)),
      thumbPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressBarPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.phaseValue != phaseValue ||
        oldDelegate.amplitudeValue != amplitudeValue;
  }
}

class _CapsuleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double height;
  final double width;

  const _CapsuleButton({required this.icon, required this.onPressed, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: const Color(0xFFD0E16C), borderRadius: BorderRadius.circular(width / 2)),
        child: Icon(icon, color: Colors.black, size: width * 0.5),
      ),
    );
  }
}

class _CircleControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  const _CircleControlButton({required this.icon, required this.onPressed, required this.size});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(color: Color(0xFFD0E16C), shape: BoxShape.circle),
        child: Icon(icon, color: Colors.black, size: size * 0.5),
      ),
    );
  }
}

class _BadgeButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  const _BadgeButton({required this.icon, required this.onPressed, required this.size});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: const ShapeDecoration(
          color: Color(0xFFD0E16C),
          shape: StarBorder.polygon(sides: 8, pointRounding: 0.4),
        ),
        child: Icon(icon, color: Colors.black, size: size * 0.45),
      ),
    );
  }
}
