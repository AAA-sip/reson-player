import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../route/material_router.dart';
import '../appbar/appbar.dart';
import 'tile.dart';
import 'tile_list.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const double _expandedHeight = 152.0;
  static const double _collapseThreshold = 76.0;

  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _scrollOffset = ValueNotifier(0.0);
  final ValueNotifier<bool> _showAppBarTitle = ValueNotifier(false);

  bool _isSnapping = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollOffset.dispose();
    _showAppBarTitle.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    _scrollOffset.value = offset;

    final shouldShow = offset >= _collapseThreshold;
    if (_showAppBarTitle.value != shouldShow) {
      _showAppBarTitle.value = shouldShow;
    }
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification && notification.direction == ScrollDirection.idle) {
      if (_isSnapping) return false;

      final offset = _scrollController.offset;

      if (offset > 0 && offset < _expandedHeight) {
        final target = offset < _expandedHeight / 2 ? 0.0 : _expandedHeight;

        _isSnapping = true;

        Future.microtask(() {
          _scrollController
              .animateTo(target, duration: const Duration(milliseconds: 250), curve: Curves.easeOutCubic)
              .then((_) => _isSnapping = false);
        });
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: SettingsAppBar(showTitle: _showAppBarTitle),
      body: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.elliptical(40, 100)),
        child: NotificationListener<ScrollNotification>(
          onNotification: _onScrollNotification,
          child: ListView(
            controller: _scrollController,
            // physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 24),
            children: [
              ExpandedTitle(scrollOffset: _scrollOffset, expandedHeight: _expandedHeight),
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
        onTap: () => materialRouter.push(MaterialRoutes.theme.path),
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
