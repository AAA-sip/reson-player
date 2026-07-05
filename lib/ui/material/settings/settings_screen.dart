import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/route/app_router.dart';
import 'appbar.dart';
import 'tile.dart';
import 'tile_list.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  static const double _expandedHeight = 152.0;

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
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            ListView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              padding: const EdgeInsets.only(top: _expandedHeight + 10, left: 12, right: 12, bottom: 24),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, bottom: 8.0),
                  child: Text(
                    'Application',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TileList(items: _firstList()),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, bottom: 12.0),
                  child: Text(
                    'Preferences',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TileList(items: _secondList()),
              ],
            ),
            SettingsAppBar(scrollOffset: _scrollOffset),
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
        leadingIcon: Symbols.palette,
        onTap: () => router.push(AppRoutes.theme.path),
      ),
      Tile.list(title: 'About', subtitle: 'Reson App v1.0.0', onTap: () {}, leadingIcon: Symbols.info),
      Tile.list(title: 'Language', subtitle: 'English', onTap: () {}, leadingIcon: Symbols.language),
    ];
  }

  List<Tile> _secondList() {
    return [
      Tile.list(
        title: 'Notifications',
        subtitle: 'Enable notifications',
        leadingIcon: Symbols.notifications,
        onTap: () {},
      ),
      Tile.list(title: 'Fonts', subtitle: 'Customize fonts', onTap: () {}, leadingIcon: Symbols.text_fields),
      Tile.list(title: 'Scale', subtitle: 'Customize scale', onTap: () {}, leadingIcon: Symbols.scale),
    ];
  }
}
