import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProviderWidget extends StatelessWidget {
  const ProviderWidget({super.key, required this.app});

  final Widget app;

  @override
  Widget build(_) =>
      //
      ProviderScope(
        child: app,
      );
}
