import 'package:flutter/material.dart'; // fuck this library

import 'app.dart';
import 'core/deps/bootstrap/bootstrap.dart';
import 'core/deps/init.dart';

/// UAHAHAH!!!
Future<void> main() async {
  await AppInit.initialize();

  runApp(const Bootstrap(app: ResonApp()));
}
