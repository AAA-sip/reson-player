import 'package:flutter/material.dart';

import '../../../../route/material/material_router.dart';
import '../../../../route/material/routes.dart';
import '../../../../theme/theme_util.dart';

class AppBarWidget extends StatelessWidget {
  final double scrollOffset;
  final double expandedHeight;
  final double collapsedHeight;

  const AppBarWidget({super.key, required this.scrollOffset, this.expandedHeight = 152.0, this.collapsedHeight = 64.0});

  @override
  Widget build(BuildContext context) {
    final double currentHeight = (expandedHeight - scrollOffset).clamp(collapsedHeight, expandedHeight);

    final double t = ((expandedHeight - currentHeight) / (expandedHeight - collapsedHeight)).clamp(0.0, 1.0);

    final double currentButtonHeight = 64.0 - (24.0 * t);

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
              left: 16.0,
              child: Opacity(
                opacity: expandedOpacity,
                child: const Text(
                  'Reson',
                  style: TextStyle(
                    fontSize: 45,
                    fontVariations: [FontVariation('wght', 700), FontVariation('wdth', 150), FontVariation('GRAD', 1)],
                    letterSpacing: -1.5,
                  ),
                ),
              ),
            ),

            // Collapsed Title
            Positioned(
              top: 0,
              left: 16,
              right: 0,
              height: collapsedHeight,
              child: Opacity(
                opacity: collapsedOpacity,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Reson',
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

            // Actions (Settings and Search)
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildActionWeight(
                      icon: Icons.search,
                      height: currentButtonHeight,
                      onPressed: () => materialRouter.push(MaterialRoutes.search.path),
                      context: context,
                    ),
                    const SizedBox(width: 8),
                    _buildActionWeight(
                      icon: Icons.settings_outlined,
                      height: currentButtonHeight,
                      onPressed: () => materialRouter.push(MaterialRoutes.settings.path),
                      context: context,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildActionWeight({
  required BuildContext context,
  required IconData icon,
  required double height,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    height: height, // The height is now dynamic and smooth
    width: 72,
    child: IconButton.filled(
      padding: EdgeInsets.zero,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor: themeData(context).colorScheme.surfaceContainerHighest,
        foregroundColor: themeData(context).colorScheme.onSurface,
        // Remove fixedSize here, let the SizedBox control it
      ),
      onPressed: onPressed,
    ),
  );
}
