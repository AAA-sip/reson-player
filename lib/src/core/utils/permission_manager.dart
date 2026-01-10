import 'package:on_audio_query/on_audio_query.dart';

class PermissionManager {
  final OnAudioQuery _audioQuery;

  PermissionManager({OnAudioQuery? audioQuery})
      : _audioQuery = audioQuery ?? OnAudioQuery();

  Future<bool> checkAndRequestPermissions() async {
    // Используем встроенный метод плагина или permission_handler
    // Для музыкального плеера на Android 13+ и ниже логика специфична,
    // плагин on_audio_query имеет удобный хелпер.
    return await _audioQuery.checkAndRequest(retryRequest: true);
  }
}
