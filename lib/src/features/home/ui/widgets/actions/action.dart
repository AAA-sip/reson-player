import 'dart:math' as math;
import 'package:flutter/material.dart';

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

    final backgroundColor =
        _pressed ? colorScheme.primaryContainer : colorScheme.surfaceContainer;
    final contentColor =
        _pressed ? colorScheme.onPrimaryContainer : colorScheme.onSurface;
    final iconColor =
        _pressed ? colorScheme.primary : colorScheme.onSurfaceVariant;

    return AnimatedScale(
      scale: _pressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      child: AnimatedContainer(
        width: widget.width,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: widget.borderRadius,
          border: Border.all(
            color: _pressed
                ? colorScheme.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            width: 1.0,
          ),
          boxShadow: _pressed
              ? []
              : [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            onHighlightChanged: (v) {
              setState(() => _pressed = v);
              widget.onHighlightChanged?.call(v);
            },
            child: Stack(
              children: [
                // Decorative Watermark Icon
                Positioned(
                  right: -12,
                  bottom: -12,
                  child: Transform.rotate(
                    angle: -math.pi / 6,
                    child: Icon(
                      widget.leadingIcon,
                      size: 84,
                      color: contentColor.withValues(alpha: 0.07),
                    ),
                  ),
                ),
                // Main Content
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Row(
                    children: [
                      Icon(widget.leadingIcon, color: iconColor, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: contentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
