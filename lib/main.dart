import 'package:flutter/widgets.dart';

import 'core/app/app.dart';
import 'core/deps/bootstrap/bootstrap.dart';
import 'core/deps/init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppInit.initialize();

  runApp(const Bootstrap(app: ResonApp()));
}
