import 'package:on_audio_query/on_audio_query.dart';

class PermissionManager {
  final OnAudioQuery _audioQuery;

  PermissionManager({OnAudioQuery? audioQuery})
      : _audioQuery = audioQuery ?? OnAudioQuery();

  Future<bool> checkAndRequestPermissions() async {
    return await _audioQuery.checkAndRequest(retryRequest: true);
  }
}
