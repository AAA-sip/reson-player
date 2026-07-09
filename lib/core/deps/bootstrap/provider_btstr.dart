import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProviderBootstrapper extends StatelessWidget {
  const ProviderBootstrapper({super.key, required this.app});

  final Widget app;

  @override
  Widget build(_) =>
      //
      ProviderScope(child: app);
}
