import 'package:flutter/material.dart';

import 'tile_widget.dart';

class TileListWidget extends StatefulWidget {
  const TileListWidget({super.key, required this.items});

  final List<TileWidget> items;

  @override
  State<TileListWidget> createState() => _TileListState();
}

class _TileListState extends State<TileListWidget> {
  int? _pressedIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.separated(
      shrinkWrap: true,
      itemCount: widget.items.length,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, int index) {
        final isNextToPressed = _pressedIndex == index || _pressedIndex == index + 1;
        return Container(color: isNextToPressed ? Colors.transparent : theme.scaffoldBackgroundColor, height: 2.0);
      },
      itemBuilder: (_, int index) {
        final item = widget.items[index];

        return TileWidget.card(
          title: item.title,
          subtitle: item.subtitle,
          trailing: item.trailing,
          onTap: item.onTap,
          leadingIcon: item.leadingIcon,
          borderRadius: _radiusForIndex(index),
          onHighlightChanged: (v) {
            setState(() {
              _pressedIndex = v ? index : null;
            });
          },
          isAbovePressed: _pressedIndex != null && _pressedIndex == index - 1,
          isBelowPressed: _pressedIndex != null && _pressedIndex == index + 1,
        );
      },
    );
  }

  BorderRadius _radiusForIndex(int index) {
    const extremeRadius = Radius.circular(28);
    const defaultRadius = Radius.circular(4);

    if (widget.items.length == 1) {
      return const BorderRadius.all(extremeRadius);
    }

    if (index == 0) {
      return const BorderRadius.only(
        topLeft: extremeRadius,
        topRight: extremeRadius,
        bottomLeft: defaultRadius,
        bottomRight: defaultRadius,
      );
    }

    if (index == widget.items.length - 1) {
      return const BorderRadius.only(
        topLeft: defaultRadius,
        topRight: defaultRadius,
        bottomLeft: extremeRadius,
        bottomRight: extremeRadius,
      );
    }

    return const BorderRadius.all(defaultRadius);
  }
}
