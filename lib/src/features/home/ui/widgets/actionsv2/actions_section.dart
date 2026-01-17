import 'package:flutter/material.dart';

import 'action.dart';

class ActionsSection extends StatelessWidget {
  const ActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        spacing: 2,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ActionWidget(
                    width: (constraints.maxWidth / 2) - 1,
                    title: 'History',
                    leadingIcon: Icons.history,
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {},
                  ),
                  ActionWidget(
                    width: (constraints.maxWidth / 2) - 1,
                    title: 'Stats',
                    leadingIcon: Icons.bar_chart,
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {},
                  ),
                ],
              );
            },
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ActionWidget(
                    width: (constraints.maxWidth / 2) - 1,
                    title: 'Favorites',
                    leadingIcon: Icons.favorite,
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {},
                  ),
                  ActionWidget(
                    width: (constraints.maxWidth / 2) - 1,
                    title: 'Collections',
                    leadingIcon: Icons.collections,
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {},
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
