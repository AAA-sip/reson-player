import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/audio_manager.dart';
import '../utils/permission_manager.dart';

final audioManagerProvider = Provider<AudioManager>((_) => AudioManager());

final permissionManagerProvider = Provider<PermissionManager>((_) => PermissionManager());

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});
