import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../utils/logger.dart';
import '../utils/shared_pref/export.dart';

class AppInit {
  AppInit._();

  static Future<void> initialize() async {
    try {
      _widgetsFlutterBinding(); // maybe huinya?
      //
      await _initDotenv();
      await _initSharedPref();
      await _initLocalization();
      await _initJustAudioBackground();
    } catch (e) {
      logger.w(e);
      rethrow;
    }
  }

  static void _widgetsFlutterBinding() async {
    WidgetsFlutterBinding.ensureInitialized();
  }

  static Future<void> _initSharedPref() async {
    await SharedPrefManager.init();
  }

  static Future<void> _initDotenv() async {
    await dotenv.load(fileName: '.env');
  }

  static Future<void> _initLocalization() async {
    await EasyLocalization.ensureInitialized();
    EasyLocalization.logger.enableBuildModes = [];
  }

  static Future<void> _initJustAudioBackground() async {
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.example.reson.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    );
  }
}
