import 'package:flutter/material.dart';

import '../widgets/actions/actions_section.dart';
import '../widgets/albums/home_albums_section.dart';
import '../widgets/artists/home_artists_section.dart';
import '../widgets/header/home_appbar.dart';
import '../widgets/tracks/home_tracks_section.dart';

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
                children: [
                  ActionsSection(),
                  HomeArtistsSection(),
                  HomeAlbumsSection(),
                  HomeTracksSection(),
                  SizedBox(height: 1000),
                ],
              ),
            ),
            HomeAppBar(scrollOffset: _scrollOffset),
          ],
        ),
      ),
    );
  }
}
