import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reson/features/home/domain/entity/song_entity.dart';
import 'package:reson/features/home/domain/repo/songs_repo.dart';

class SongsRepoImpl implements SongsRepo {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  Future<List<SongEntity>> getSongs() async {
    // Request permission if not granted
    // Note: On Android 13+, use photos/audio permissions. 
    // OnAudioQuery has a helper but sometimes manual is better for granular control.
    // For MVP we try the plugin's check.
    
    bool hasPermission = await _audioQuery.checkAndRequest(retryRequest: true);
    
    if (!hasPermission) {
       // Manual fallback for Android 13+ if plugin fails (sometimes happens)
       // or just return empty.
       // Let's assume the plugin helper works for MVP.
       return [];
    }

    List<SongModel> songs = await _audioQuery.querySongs(
      sortType: SongSortType.DATE_ADDED,
      orderType: OrderType.DESC_OR_GREATER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    return songs.map((song) {
      return SongEntity(
        id: song.id,
        title: song.title,
        artist: song.artist ?? "Unknown Artist",
        uri: song.data,
        duration: song.duration ?? 0,
      );
    }).toList();
  }
}
