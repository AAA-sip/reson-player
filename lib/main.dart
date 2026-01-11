import 'package:flutter/material.dart';

import 'app.dart';
import 'src/core/deps/provider_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderWidget(app: ResonApp()));
}
