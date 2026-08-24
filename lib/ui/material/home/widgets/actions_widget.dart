import 'package:flutter/material.dart';

import '../../../../core/localization/strings.g.dart';
import 'actions/action_widget.dart';

class ActionsWidget extends StatelessWidget {
  const ActionsWidget({super.key});

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
                    title: Strings.home.actions.history,
                    leadingIcon: Icons.history,
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {},
                  ),
                  ActionWidget(
                    width: (constraints.maxWidth / 2) - 1,
                    title: Strings.home.actions.stats,
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
                    title: Strings.home.actions.favorites,
                    leadingIcon: Icons.favorite,
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {},
                  ),
                  ActionWidget(
                    width: (constraints.maxWidth / 2) - 1,
                    title: Strings.home.actions.collections,
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
