import 'package:flutter/material.dart';

import 'src/core/route/app_router.dart';
import 'src/core/theme/light.dart';

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
