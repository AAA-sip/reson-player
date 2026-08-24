import 'package:flutter/material.dart';
import 'package:material_shapes/material_shapes.dart';

class CapsuleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double height;
  final double width;

  const CapsuleButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: colorScheme.primary, borderRadius: BorderRadius.circular(width / 2)),
        child: Icon(icon, color: colorScheme.onPrimary, size: width * 0.5),
      ),
    );
  }
}

class CircleControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  const CircleControlButton({super.key, required this.icon, required this.onPressed, required this.size});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: colorScheme.primary, shape: BoxShape.circle),
        child: Icon(icon, color: colorScheme.onPrimary, size: size * 0.5),
      ),
    );
  }
}

class BadgeButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  const BadgeButton({super.key, required this.icon, required this.onPressed, required this.size});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          MaterialShapes.softBurst(color: colorScheme.secondary, size: size),
          Icon(icon, color: colorScheme.onPrimary, size: size * 0.5),
        ],
      ),
    );
  }
}
