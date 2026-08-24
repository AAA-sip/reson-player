import 'package:flutter/material.dart';

import '../../../../ui/material/player/widgets/mini_player_widget.dart';

class ScreenWithPlayer extends StatelessWidget {
  const ScreenWithPlayer({required this.child, super.key});

  final Widget child;

  @override
  Widget build(_) =>
      //
      Scaffold(
        body: Stack(
          children: [
            child,
            const Positioned(left: 0, right: 0, bottom: 0, child: SafeArea(top: false, child: MiniPlayerWidget())),
          ],
        ),
      );
}
