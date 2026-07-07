import 'package:flutter/material.dart';

class BounceScrollBehavior extends MaterialScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}

class AppInit {
  AppInit._();

  static Future<void> initialize() async {
    await _initDotenv();
    await _initSharedPref();
    await _initLocalization();
  }

  static Future<void> _initSharedPref() async {
    await SharedPrefSystem.init();
  }

  static Future<void> _initDotenv() async {
    await dotenv.load(fileName: '.env');
  }

  static Future<void> _initLocalization() async {
    await EasyLocalization.ensureInitialized();
    EasyLocalization.logger.enableBuildModes = [];
  }
}
