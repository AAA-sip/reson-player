import 'package:flutter/material.dart';
import 'package:material_shapes/material_shapes.dart';

class ActionWidget extends StatefulWidget {
  const ActionWidget({
    super.key,
    required this.title,
    required this.width,
    required this.borderRadius,
    required this.leadingIcon,
    this.onTap,
    this.onHighlightChanged,
  });

  final String title;
  final double width;
  final BorderRadius borderRadius;
  final IconData leadingIcon;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onHighlightChanged;

  @override
  State<ActionWidget> createState() => _ActionWidgetState();
}

class _ActionWidgetState extends State<ActionWidget> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    BorderRadius effectiveRadius = widget.borderRadius;

    final decoration = BoxDecoration(
      color: colorScheme.surfaceContainer,
      borderRadius: _pressed ? BorderRadius.circular(28) : effectiveRadius,
      border: Border.all(color: _pressed ? colorScheme.primary.withValues(alpha: 0.5) : Colors.transparent, width: 1.5),
    );

    final iconColor = _pressed ? colorScheme.primary : colorScheme.onSurfaceVariant;
    final shapeColor = _pressed ? colorScheme.primaryContainer : colorScheme.surfaceContainerHighest;
    final iconFill = _pressed ? 1.0 : 0.0;

    return AnimatedContainer(
      width: widget.width,
      duration: const Duration(milliseconds: 150),
      curve: Curves.fastOutSlowIn,
      decoration: decoration,
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: colorScheme.primary.withValues(alpha: 0.1),
          splashColor: colorScheme.primary.withValues(alpha: 0.1),
          onTap: widget.onTap,
          onHighlightChanged: (v) {
            setState(() => _pressed = v);
            widget.onHighlightChanged?.call(v);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: _pressed ? FontWeight.bold : FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: MaterialShapes.puffyDiamond(size: 40, color: shapeColor.withOpacity(0.3)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
