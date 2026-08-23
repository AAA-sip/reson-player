import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/localization/strings.g.dart';
import '../../../../core/localization/supported_locales.dart';
import '../../../../route/material_router.dart';
import '../appbar/appbar.dart';
import 'language_picker.dart';
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
    context.locale;

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
                  Strings.settings.application,
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
                  Strings.settings.preferences,
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
                  Strings.settings.preferences,
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
        title: Strings.settings.appearance,
        subtitle: Strings.settings.appearanceSubtitle,
        leadingIcon: Symbols.palette,
        onTap: () => materialRouter.push(MaterialRoutes.theme.path),
      ),
      Tile.list(
        title: Strings.settings.about,
        subtitle: Strings.settings.aboutSubtitle,
        onTap: () {},
        leadingIcon: Symbols.info,
      ),
      Tile.list(
        title: Strings.settings.language,
        subtitle: localeDisplayName(context.locale),
        leadingIcon: Symbols.language,
        onTap: () => showLanguagePicker(context),
      ),
    ];
  }

  List<Tile> _secondList() {
    return [
      Tile.list(
        title: Strings.settings.notifications,
        subtitle: Strings.settings.notificationsSubtitle,
        leadingIcon: Symbols.notifications,
        onTap: () {},
      ),
      Tile.list(
        title: Strings.settings.fonts,
        subtitle: Strings.settings.fontsSubtitle,
        onTap: () {},
        leadingIcon: Symbols.text_fields,
      ),
      Tile.list(
        title: Strings.settings.scale,
        subtitle: Strings.settings.scaleSubtitle,
        onTap: () {},
        leadingIcon: Symbols.scale,
      ),
    ];
  }
}
