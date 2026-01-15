import 'package:flutter/material.dart';

import '../../../../core/route/app_router.dart';
import '../widgets/albums/home_albums_section.dart';
import '../widgets/artists/home_artists_section.dart';
import '../widgets/tracks/home_tracks_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(_) =>
      //
      Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          leading: const SizedBox(),
          leadingWidth: 0,
          actions: [
            IconButton.filled(
              onPressed: () => router.push(AppRoutes.settings.path),
              icon: const Icon(Icons.settings_outlined),
            ),
            IconButton.filled(
              onPressed: () => router.push(AppRoutes.search.path),
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        body: const SingleChildScrollView(
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeAlbumsSection(),
              HomeArtistsSection(),
              HomeTracksSection(),
            ],
          ),
        ),
      );
}
