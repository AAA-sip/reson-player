import 'package:flutter/material.dart';

import 'src/core/deps/init.dart';
import 'src/core/route/app_router.dart';
import 'src/core/theme/dark.dart';

class ResonApp extends StatelessWidget {
  const ResonApp({super.key});

  @override
  Widget build(_) =>
      //
      MaterialApp.router(
        title: 'Reson',
        theme: darkTheme,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        scrollBehavior: BounceScrollBehavior(),
      );
}
