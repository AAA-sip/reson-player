import 'package:flutter/material.dart';

import 'export.dart';

class Bootstrap extends StatelessWidget {
  const Bootstrap({super.key, required this.app});

  final Widget app;

  @override
  Widget build(_) =>
      //
      ProviderBootstrapper(app: LocalBootstrap(app: app));
}
