import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/material.dart' show Colors, ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app/app_style.dart';
import '../../theme/provider/theme_provider.dart';

class CupertinoSettingsScreen extends ConsumerWidget {
  const CupertinoSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeConfig = ref.watch(themeControllerProvider);
    final appStyle = ref.watch(appStyleControllerProvider);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Settings')),
      child: SafeArea(
        child: ListView(
          children: [
            CupertinoListSection.insetGrouped(
              header: const Text('Appearance'),
              hasLeading: false,
              children: [
                _SettingRow(
                  title: 'Theme Mode',
                  child: CupertinoSlidingSegmentedControl<ThemeMode>(
                    groupValue: themeConfig.themeMode,
                    onValueChanged: (mode) {
                      if (mode != null) ref.read(themeControllerProvider.notifier).setThemeMode(mode);
                    },
                    children: const {
                      ThemeMode.system: Text('Auto'),
                      ThemeMode.light: Text('Light'),
                      ThemeMode.dark: Text('Dark'),
                    },
                  ),
                ),
                _SettingRow(
                  title: 'Tint Color',
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ...Colors.primaries.map(
                        (color) => _ColorSwatch(
                          color: color,
                          selected: themeConfig.seedColor.toARGB32() == color.toARGB32(),
                          onTap: () => ref.read(themeControllerProvider.notifier).setSeedColor(color),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              header: const Text('Application'),
              hasLeading: false,
              children: [
                _SettingRow(
                  title: 'App Style',
                  footer: 'Switches the design system of the whole app',
                  child: CupertinoSlidingSegmentedControl<AppStyle>(
                    groupValue: appStyle,
                    onValueChanged: (style) {
                      if (style != null) ref.read(appStyleControllerProvider.notifier).setStyle(style);
                    },
                    children: const {AppStyle.material: Text('Material'), AppStyle.cupertino: Text('Cupertino')},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({required this.title, required this.child, this.footer});

  final String title;
  final String? footer;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(title, style: theme.textTheme.textStyle.copyWith(fontSize: 15)),
          child,
          if (footer != null) Text(footer!, style: theme.textTheme.tabLabelTextStyle.copyWith(fontSize: 12)),
        ],
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({required this.color, required this.selected, required this.onTap});

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: selected ? Border.all(width: 3) : null),
        child: selected ? const Icon(CupertinoIcons.check_mark, size: 20) : null,
      ),
    );
  }
}
