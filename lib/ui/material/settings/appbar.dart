import 'package:flutter/material.dart';

import '../../../core/route/app_router.dart';
import '../../../core/theme/theme_util.dart';

class SettingsAppBar extends StatelessWidget {
  final double scrollOffset;
  final double expandedHeight;
  final double collapsedHeight;

  const SettingsAppBar({
    super.key,
    required this.scrollOffset,
    this.expandedHeight = 152.0,
    this.collapsedHeight = 64.0,
  });

  @override
  Widget build(BuildContext context) {
    final double currentHeight = (expandedHeight - scrollOffset).clamp(collapsedHeight, expandedHeight);

    final double t = ((expandedHeight - currentHeight) / (expandedHeight - collapsedHeight)).clamp(0.0, 1.0);

    final double expandedOpacity = (1 - (t / 0.4)).clamp(0.0, 1.0);
    final double collapsedOpacity = ((t - 0.6) / 0.4).clamp(0.0, 1.0);

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: currentHeight,
      child: Container(
        color: colorScheme.surface,
        child: Stack(
          children: [
            // Expanded Title
            Positioned(
              bottom: 16.0,
              left: 20.0,
              child: Opacity(
                opacity: expandedOpacity,
                child: Transform.scale(
                  scaleY: 1.0 + (scrollOffset < 0 ? -scrollOffset / 70 : 0.0), // --
                  alignment: Alignment.topLeft,
                  child: const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 45,
                      fontVariations: [
                        FontVariation('wght', 700),
                        FontVariation('wdth', 150),
                        FontVariation('GRAD', 1),
                      ],
                      letterSpacing: -1.5,
                    ),
                  ),
                ),
              ),
            ),

            // Collapsed Title
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: collapsedHeight,
              child: Opacity(
                opacity: collapsedOpacity,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Settings',
                    style: textTheme.titleLarge!.copyWith(
                      fontVariations: [
                        const FontVariation('wght', 900),
                        const FontVariation('wdth', 150),
                        const FontVariation('GRAD', 1),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Back Button
            Positioned(
              top: 8.0,
              left: 8.0,
              child: SafeArea(
                child: IconButton.filled(
                  icon: const Icon(Icons.arrow_back),
                  style: IconButton.styleFrom(
                    backgroundColor: themeData(context).colorScheme.surfaceContainerHighest,
                    foregroundColor: themeData(context).colorScheme.onSurface,
                  ),
                  onPressed: () => router.pop(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
