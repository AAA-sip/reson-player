import 'package:flutter/material.dart';

import '../../../../../core/theme/theme_util.dart';

class Tile extends StatefulWidget {
  const Tile._({
    super.key,
    required this.title,
    required this.color,
    required this.borderRadius,
    required this.leadingIcon,
    this.onTap,
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
  }) {
    return Tile._(
      key: key,
      title: title,
      subtitle: subtitle,
      leadingIcon: leadingIcon,
      trailing: trailing,
      onTap: onTap,
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
    final currentRadius = _pressed
        ? BorderRadius.circular(28)
        : widget.borderRadius;

    final currentBorder = _pressed
        ? Border.all(color: themeData(context).colorScheme.primary, width: 1.5)
        : null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: currentRadius,
        border: currentBorder,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          // highlightColor: themeData(
          //   context,
          // ).colorScheme.primary.withValues(alpha: 0.05),
          // splashColor: themeData(
          //   context,
          // ).colorScheme.primary.withValues(alpha: 0.1),
          onTap: widget.onTap,
          onHighlightChanged: (v) => setState(() => _pressed = v),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Row(
              children: [
                Icon(widget.leadingIcon),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.subtitle != null)
                        Text(
                          widget.subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                widget.trailing ??
                    const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
