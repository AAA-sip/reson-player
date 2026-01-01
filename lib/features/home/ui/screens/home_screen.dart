import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reson'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                context.push('/search');
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                context.push('/settings');
              },
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Artists'),
              Tab(text: 'Albums'),
              Tab(text: 'Playlists'),
              Tab(text: 'Tracks'),
              Tab(text: 'Genres'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Artists')),
            Center(child: Text('Albums')),
            Center(child: Text('Playlists')),
            Center(child: Text('Tracks')),
            Center(child: Text('Genres')),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              context.push('/player');
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Now Playing'),
          ),
        ),
      ),
    );
  }
}
