import 'package:flutter/material.dart';

import 'core/route/app_router.dart';
import 'core/theme/light.dart';

class ResonApp extends StatelessWidget {
  const ResonApp({super.key});

  @override
  Widget build(_) =>
      //
      MaterialApp.router(
        title: 'Reson',
        theme: lightTheme,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      );
}
