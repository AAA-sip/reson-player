import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/route/app_router.dart';
import '../widgets/settings/appbar.dart';
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
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              padding: const EdgeInsets.only(top: _expandedHeight + 10, left: 10, right: 10, bottom: 10),
              children: [
                //
                TileList(items: _firstList()),
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
}
