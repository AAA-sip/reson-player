import 'package:flutter/material.dart';

class Tile extends StatefulWidget {
  const Tile._({
    super.key,
    required this.title,
    required this.color,
    required this.borderRadius,
    required this.leadingIcon,
    this.onTap,
    this.onHighlightChanged,
    this.isAbovePressed = false,
    this.isBelowPressed = false,
    this.trailing,
    this.subtitle,
  });

  final String title;
  final Color color;
  final BorderRadius borderRadius;
  final IconData leadingIcon;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onHighlightChanged;
  final bool isAbovePressed;
  final bool isBelowPressed;

  //
  factory Tile.list({
    Key? key,
    required String title,
    required IconData leadingIcon,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Tile._(
      key: key,
      title: title,
      subtitle: subtitle,
      leadingIcon: leadingIcon,
      trailing: trailing,
      onTap: onTap,
      color: Colors.transparent,
      borderRadius: BorderRadius.zero,
    );
  }

  //
  factory Tile.card({
    Key? key,
    required String title,
    required Color color,
    required IconData leadingIcon,
    required BorderRadius borderRadius,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    ValueChanged<bool>? onHighlightChanged,
    bool isAbovePressed = false,
    bool isBelowPressed = false,
  }) {
    return Tile._(
      key: key,
      title: title,
      subtitle: subtitle,
      leadingIcon: leadingIcon,
      trailing: trailing,
      onTap: onTap,
      onHighlightChanged: onHighlightChanged,
      isAbovePressed: isAbovePressed,
      isBelowPressed: isBelowPressed,
      color: color,
      borderRadius: borderRadius,
    );
  }

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    BorderRadius effectiveRadius = widget.borderRadius;
    if (widget.isAbovePressed) {
      effectiveRadius = BorderRadius.only(
        topLeft: const Radius.circular(24),
        topRight: const Radius.circular(24),
        bottomLeft: effectiveRadius.bottomLeft,
        bottomRight: effectiveRadius.bottomRight,
      );
    } else if (widget.isBelowPressed) {
      effectiveRadius = BorderRadius.only(
        topLeft: effectiveRadius.topLeft,
        topRight: effectiveRadius.topRight,
        bottomLeft: const Radius.circular(24),
        bottomRight: const Radius.circular(24),
      );
    }

    final decoration = BoxDecoration(
      color: widget.color == Colors.transparent ? Colors.transparent : colorScheme.surfaceContainer,
      borderRadius: _pressed ? BorderRadius.circular(28) : effectiveRadius,
      border: Border.all(color: _pressed ? colorScheme.primary.withValues(alpha: 0.5) : Colors.transparent, width: 1.5),
    );

    final iconColor = _pressed ? colorScheme.primary : colorScheme.onSurfaceVariant;
    final pillColor = _pressed ? colorScheme.primaryContainer : colorScheme.surfaceContainerHighest;
    final iconFill = _pressed ? 1.0 : 0.0;

    return AnimatedContainer(
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
            child: Row(
              children: [
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Container(
                      width: 48,
                      height: 32,
                      decoration: ShapeDecoration(color: pillColor, shape: const StadiumBorder()),
                    ),
                    Icon(widget.leadingIcon, fill: iconFill, color: iconColor),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      if (widget.subtitle != null)
                        Text(
                          widget.subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                    ],
                  ),
                ),
                widget.trailing ??
                    Icon(Icons.chevron_right, size: 20, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
