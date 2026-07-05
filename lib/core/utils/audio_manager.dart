import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../../model/song_model.dart';

class AudioManager {
  final AudioPlayer _player = AudioPlayer();
  
  // Expose player for streams
  AudioPlayer get player => _player;

  Future<void> init() async {
    // Audio session setup could go here
  }

  Future<void> setPlaylist(List<SongModel> songs, {int initialIndex = 0}) async {
    final audioSources = songs.map((song) {
      return AudioSource.uri(
        Uri.parse(song.uri),
        tag: MediaItem(
          id: song.id.toString(),
          title: song.title,
          artist: song.artist,
          artUri: song.imageUrl != null ? Uri.parse(song.imageUrl!) : null,
          extras: {'song': song}, // Keep original entity if needed
        ),
      );
    }).toList();

    await _player.setAudioSource(
      ConcatenatingAudioSource(children: audioSources),
      initialIndex: initialIndex,
    );
  }

  Future<void> play() => _player.play();
  Future<void> pause() => _player.pause();
  Future<void> stop() => _player.stop();
  Future<void> seek(Duration position) => _player.seek(position);
  Future<void> next() => _player.seekToNext();
  Future<void> previous() => _player.seekToPrevious();
  
  void dispose() {
    _player.dispose();
  }
}
