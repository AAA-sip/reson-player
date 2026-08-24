import 'package:flutter/material.dart';

import 'widgets/actions_widget.dart';
import 'widgets/albums_widget.dart';
import 'widgets/appbar_widget.dart';
import 'widgets/artists_widget.dart';
import 'widgets/tracks_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: _expandedHeight + 10, bottom: 24),
              child: const Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [ActionsWidget(), ArtistsWidget(), AlbumsWidget(), TracksWidget()],
              ),
            ),
            AppBarWidget(scrollOffset: _scrollOffset),
          ],
        ),
      ),
    );
  }
}
