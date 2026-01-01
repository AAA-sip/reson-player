import 'package:flutter/material.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_note, size: 100),
            SizedBox(height: 20),
            Text('Song Title', style: TextStyle(fontSize: 24)),
            Text('Artist Name', style: TextStyle(fontSize: 18, color: Colors.grey)),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.skip_previous, size: 40),
                SizedBox(width: 20),
                Icon(Icons.play_circle_fill, size: 64),
                SizedBox(width: 20),
                Icon(Icons.skip_next, size: 40),
              ],
            )
          ],
        ),
      ),
    );
  }
}
