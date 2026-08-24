import 'package:flutter/material.dart';

class TileWidget extends StatefulWidget {
  const TileWidget._({
    super.key,
    required this.title,
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
  final BorderRadius borderRadius;
  final IconData leadingIcon;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onHighlightChanged;
  final bool isAbovePressed;
  final bool isBelowPressed;

  //
  factory TileWidget.list({
    Key? key,
    required String title,
    required IconData leadingIcon,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return TileWidget._(
      key: key,
      title: title,
      subtitle: subtitle,
      leadingIcon: leadingIcon,
      trailing: trailing,
      onTap: onTap,
      borderRadius: BorderRadius.zero,
    );
  }

  //
  factory TileWidget.card({
    Key? key,
    required String title,
    required IconData leadingIcon,
    required BorderRadius borderRadius,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    ValueChanged<bool>? onHighlightChanged,
    bool isAbovePressed = false,
    bool isBelowPressed = false,
  }) {
    return TileWidget._(
      key: key,
      title: title,
      subtitle: subtitle,
      leadingIcon: leadingIcon,
      trailing: trailing,
      onTap: onTap,
      onHighlightChanged: onHighlightChanged,
      isAbovePressed: isAbovePressed,
      isBelowPressed: isBelowPressed,
      borderRadius: borderRadius,
    );
  }

  @override
  State<TileWidget> createState() => _TileWidgetState();
}

class _TileWidgetState extends State<TileWidget> {
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
      color: colorScheme.surfaceContainer,
      borderRadius: _pressed ? BorderRadius.circular(28) : effectiveRadius,
      border: Border.all(color: _pressed ? colorScheme.primary.withValues(alpha: 0.5) : Colors.transparent, width: 1.5),
    );

    final iconColor = _pressed ? colorScheme.primary : colorScheme.onSurfaceVariant;
    final shapeColor = _pressed ? colorScheme.primaryContainer : colorScheme.surfaceContainerHighest;
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
                    // Transform.rotate(
                    //   angle: math.Random().nextDouble() * 2 * math.pi,
                    //   child: MaterialShapes.puffyDiamond(size: 32, color: shapeColor),
                    // ),
                    Container(
                      width: 48,
                      height: 32,
                      decoration: ShapeDecoration(color: shapeColor, shape: const StadiumBorder()),
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
