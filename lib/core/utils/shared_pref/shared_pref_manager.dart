import 'package:shared_preferences/shared_preferences.dart';

import '../logger.dart';
import 'shared_pref_keys.dart';

///
///
/// Manages shared preferences for the application.
class SharedPrefManager {
  SharedPrefManager._();

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get _prefsMan {
    if (_prefs == null) {
      logger.w('SharedPrefManager is not initialized');
      throw Exception('SharedPrefManager is not initialized');
    }

    return _prefs!;
  }

  static Future<void> saveData(SharedPrefKey key, dynamic value) async {
    if (value == null) return;

    if (value is String) {
      await _prefsMan.setString(key.name, value);
      return;
    } else if (value is int) {
      await _prefsMan.setInt(key.name, value);
      return;
    } else if (value is bool) {
      await _prefsMan.setBool(key.name, value);
      return;
    } else if (value is double) {
      await _prefsMan.setDouble(key.name, value);
      return;
    } else {
      logger.w('Unsupported data type: $value');
      throw Exception('Unsupported data type: $value');
    }
  }

  static T? getData<T>(SharedPrefKey key) {
    return _prefsMan.get(key.name) as T?;
  }

  static void removeData(SharedPrefKey key) async {
    await _prefsMan.remove(key.name);
  }
}
