import 'package:flutter/material.dart'; // fuck this library

import 'core/app/app.dart';
import 'core/deps/bootstrap/bootstrap.dart';
import 'core/deps/init.dart';

/// UAHAHAH!!!
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppInit.initialize();

  runApp(const Bootstrap(app: ResonApp()));
}
