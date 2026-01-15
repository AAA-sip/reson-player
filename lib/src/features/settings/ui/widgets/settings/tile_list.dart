import 'package:flutter/material.dart';

import '../../../../../core/theme/theme_util.dart';
import 'tile.dart';

class TileList extends StatelessWidget {
  const TileList({super.key, required this.items});

  final List<Tile> items;

  @override
  Widget build(BuildContext context) =>
      //
      ListView.separated(
        shrinkWrap: true,
        itemCount: items.length,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (_, _) => Container(
          color: themeData(context).scaffoldBackgroundColor,
          height: 1.5,
        ),
        itemBuilder: (_, int index) {
          final item = items[index];

          return Tile.card(
            title: item.title,
            subtitle: item.subtitle,
            trailing: item.trailing,
            onTap: item.onTap,
            color: themeData(context).colorScheme.surfaceContainer,
            leadingIcon: item.leadingIcon,
            borderRadius: _radiusForIndex(index),
          );
        },
      );

  //
  BorderRadius _radiusForIndex(int index) {
    const extremeRadius = Radius.circular(20);
    const defaultRadius = Radius.circular(5);

    if (items.length == 1) {
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

    if (index == items.length - 1) {
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
