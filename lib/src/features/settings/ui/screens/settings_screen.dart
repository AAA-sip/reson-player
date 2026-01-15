import 'package:flutter/material.dart';

import '../../../../core/route/app_router.dart';
import '../widgets/settings/tile.dart';
import '../widgets/settings/tile_list.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  static const double _expandedHeight = 152.0;
  static const double _collapsedHeight =
      64.0; // Standard M3 tall toolbar height

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double currentHeight = (_expandedHeight - _scrollOffset).clamp(
      _collapsedHeight,
      _expandedHeight,
    );

    // Calculate percentage of collapse (0.0 = expanded, 1.0 = collapsed)
    final double t =
        ((_expandedHeight - currentHeight) /
                (_expandedHeight - _collapsedHeight))
            .clamp(0.0, 1.0);

    // Opacity Logic: Strict separation
    // Expanded title fades out from t=0.0 to t=0.4
    final double expandedOpacity = (1 - (t / 0.4)).clamp(0.0, 1.0);

    // Collapsed title fades in from t=0.6 to t=1.0
    // This ensures they never overlap and there's a small transition gap
    final double collapsedOpacity = ((t - 0.6) / 0.4).clamp(0.0, 1.0);

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Body Content
            ListView(
              controller: _scrollController,
              // Add padding equal to expanded height so content starts below it
              padding: const EdgeInsets.only(
                top: _expandedHeight + 10,
                left: 10,
                right: 10,
                bottom: 10,
              ),
              children: [
                TileList(items: _firstList()),
                // Dummy content
                ...List.generate(
                  15,
                  (index) => Tile.list(
                    title: 'Option $index',
                    subtitle: 'Description for option $index',
                    onTap: () {},
                    leadingIcon: Icons.settings,
                  ),
                ),
              ],
            ),

            // Collapsing AppBar Background & Content
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: currentHeight,
              child: Container(
                color: colorScheme.surface,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 16.0,
                      left: 16.0,
                      child: Opacity(
                        opacity: expandedOpacity,
                        child: const Text(
                          'Settings',
                          style: TextStyle(
                            fontFamily: 'RobotoFlex',
                            fontSize: 45,
                            fontVariations: [
                              FontVariation('wght', 900),
                              FontVariation('wdth', 150),
                              FontVariation('GRAD', 1),
                            ],
                            letterSpacing: -1.5,
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: _collapsedHeight,
                      child: Opacity(
                        opacity: collapsedOpacity,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text('Settings', style: textTheme.titleLarge),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Positioned(
              top: 8.0,
              left: 8.0,
              child: SafeArea(child: BackButton()),
            ),
          ],
        ),
      ),
    );
  }

  List<Tile> _firstList() {
    return [
      Tile.list(
        title: 'Appearance',
        subtitle: 'Theme, color, contrast',
        onTap: () => router.push(AppRoutes.theme.path),
        leadingIcon: Icons.palette,
      ),
      Tile.list(
        title: 'About',
        subtitle: 'Reson App v1.0.0',
        onTap: () {},
        leadingIcon: Icons.info,
      ),
      Tile.list(
        title: 'Language',
        subtitle: 'English',
        onTap: () {},
        leadingIcon: Icons.language,
      ),
    ];
  }
}
