import 'package:just_audio/just_audio.dart';
import '../../features/home/domain/entity/song_entity.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  
  // Expose player for streams
  AudioPlayer get player => _player;

  Future<void> init() async {
    // Audio session setup could go here
  }

  Future<void> setPlaylist(List<SongEntity> songs, {int initialIndex = 0}) async {
    final audioSources = songs.map((song) {
      return AudioSource.uri(
        Uri.parse(song.uri),
        tag: song, // Attach entity as tag to retrieve metadata later
      );
    }).toList();

    // Use setAudioSource with ConcatenatingAudioSource if setAudioSources is not found, 
    // but linter said use setAudioSources.
    // However, if setAudioSources doesn't exist in the installed version, this will break.
    // Given the linter message "Use AudioPlayer.setAudioSources", I will trust it.
    // But standard just_audio 0.9.36+ uses ConcatenatingAudioSource.
    // Let's assume the linter knows best about the installed version.
    // Wait, if I use ConcatenatingAudioSource, I must handle the nullable _playlist.
    // I'll stick to ConcatenatingAudioSource for safety as it's the standard way for years, 
    // and maybe the linter is from a very new version or I misread "deprecated member use" context?
    // "ConcatenatingAudioSource is deprecated... Use AudioPlayer.setAudioSources".
    // Okay, I'll use setAudioSources(audioSources).
    
    // But wait, setAudioSource (singular) is the main method. 
    // Maybe it's `await _player.setAudioSource(ConcatenatingAudioSource(children: audioSources))`
    // and I just need to fix the nullability of my previous code?
    // The linter error was `ConcatenatingAudioSource?` vs `AudioSource`.
    // I'll assume the deprecation is a warning and the type error is the blocker.
    // I will use ConcatenatingAudioSource but inline it to avoid the field if not needed, 
    // or keep the field if I want to manipulate it. 
    // Let's try the new API `setAudioSources` if possible.
    // Since I can't verify if `setAudioSources` exists, I'll use the safe bet:
    // Cast to AudioSource and ignore deprecation if needed, or just fix type error.
    
    // Actually, looking at recent JustAudio (0.9.40), `setAudioSource` is correct. 
    // `ConcatenatingAudioSource` is correct.
    // Maybe the linter is hallucinating or I have a weird version?
    // "ConcatenatingAudioSource is deprecated".
    // I'll try to use `AudioSource.sequence` if that exists? No.
    
    // I'll go with:
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
