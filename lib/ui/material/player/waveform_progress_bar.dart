import 'dart:math';
import 'package:flutter/material.dart';

// --- CONFIGURATION ---
class WaveConfig {
  // Values customize
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
  late AnimationController _phaseController;
  late AnimationController _amplitudeController;

  @override
  void initState() {
    super.initState();

    _phaseController = AnimationController(vsync: this, duration: WaveConfig.waveSpeedDuration);

    _amplitudeController = AnimationController(
      vsync: this,
      duration: WaveConfig.shrinkDuration,
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
        _phaseController.repeat();
        _amplitudeController.forward();
      } else {
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
    final primaryColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onHorizontalDragUpdate: (details) => _seek(context, details.localPosition),
      onTapDown: (details) => _seek(context, details.localPosition),
      child: Container(
        width: double.infinity,
        height: 50,
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: AnimatedBuilder(
          animation: Listenable.merge([_phaseController, _amplitudeController]),
          builder: (context, child) {
            return CustomPaint(
              painter: _ProgressBarPainter(
                progress: progress,
                phaseValue: _phaseController.value,
                amplitudeValue: _amplitudeController.value,
                color: primaryColor,
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
  final double phaseValue;
  final double amplitudeValue;
  final Color color;

  _ProgressBarPainter({
    required this.progress,
    required this.phaseValue,
    required this.amplitudeValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final thumbX = size.width * progress;

    final currentAmplitude = WaveConfig.waveHeight * amplitudeValue;
    final waveShift = phaseValue * 2 * pi;
    final endActiveX = thumbX - WaveConfig.gap;

    final activePaint = Paint()
      ..color = color
      ..strokeWidth = WaveConfig.strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final inactivePaint = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = WaveConfig.strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final thumbPaint = Paint()
      ..color = color
      ..strokeWidth = WaveConfig.strokeWidth
      ..strokeCap = StrokeCap.round;

    if (endActiveX > 0) {
      final activePath = Path();

      final y0 = centerY + currentAmplitude * sin(0 * WaveConfig.waveFrequency + waveShift);
      activePath.moveTo(0, y0);

      for (double x = 1; x <= endActiveX; x += 1) {
        final y = centerY + currentAmplitude * sin(x * WaveConfig.waveFrequency + waveShift);
        activePath.lineTo(x, y);
      }

      canvas.drawPath(activePath, activePaint);
    }

    final startInactiveX = thumbX + WaveConfig.gap;
    if (startInactiveX < size.width) {
      canvas.drawLine(Offset(startInactiveX, centerY), Offset(size.width, centerY), inactivePaint);
    }

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
