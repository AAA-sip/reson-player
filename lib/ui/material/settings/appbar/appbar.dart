import 'package:flutter/material.dart';

import '../../../../route/material_router.dart';
import '../../../../theme/theme_util.dart';

class SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ValueNotifier<bool> showTitle;

  const SettingsAppBar({super.key, required this.showTitle});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: showTitle,
      builder: (context, visible, _) {
        return AppBar(
          backgroundColor: themeData(context).colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton.filled(
            icon: const Icon(Icons.arrow_back),
            style: IconButton.styleFrom(
              backgroundColor: themeData(context).colorScheme.surfaceContainerHighest,
              foregroundColor: themeData(context).colorScheme.onSurface,
            ),
            onPressed: () => materialRouter.pop(),
          ),
          title: AnimatedOpacity(
            opacity: visible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 150),
            child: const Text(
              'Settings',
              style: TextStyle(
                fontVariations: [FontVariation('wght', 900), FontVariation('wdth', 150), FontVariation('GRAD', 1)],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ExpandedTitle extends StatelessWidget {
  final ValueNotifier<double> scrollOffset;
  final double expandedHeight;

  const ExpandedTitle({super.key, required this.scrollOffset, required this.expandedHeight});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: scrollOffset,
      builder: (context, offset, _) {
        final t = (offset / expandedHeight).clamp(0.0, 1.0);
        final opacity = (1 - t / 0.6).clamp(0.0, 1.0);

        return IgnorePointer(
          ignoring: opacity == 0,
          child: Opacity(
            opacity: opacity,
            child: Container(
              height: expandedHeight,
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
              child: const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 45,
                  fontVariations: [FontVariation('wght', 700), FontVariation('wdth', 150), FontVariation('GRAD', 1)],
                  letterSpacing: -1.5,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
