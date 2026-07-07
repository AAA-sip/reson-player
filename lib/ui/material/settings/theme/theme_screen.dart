import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/model/theme_config.dart';
import '../../../../core/theme/provider/theme_provider.dart';

class ThemeScreen extends ConsumerWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeConfig = ref.watch(themeControllerProvider);
    final notifier = ref.read(themeControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Appearance')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Theme Mode', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          SegmentedButton<ThemeMode>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(
                value: ThemeMode.system,
                label: Text('System'),
                icon: Icon(Icons.brightness_auto),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                label: Text('Light'),
                icon: Icon(Icons.light_mode),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                label: Text('Dark'),
                icon: Icon(Icons.dark_mode),
              ),
            ],
            selected: {themeConfig.themeMode},
            onSelectionChanged: (Set<ThemeMode> newSelection) {
              notifier.setThemeMode(newSelection.first);
            },
          ),
          const SizedBox(height: 24),
          Text('Contrast Level', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          SegmentedButton<ContrastLevel>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(
                value: ContrastLevel.normal,
                label: Text('Standard'),
              ),
              ButtonSegment(
                value: ContrastLevel.medium,
                label: Text('Medium'),
              ),
              ButtonSegment(
                value: ContrastLevel.high,
                label: Text('High'),
              ),
            ],
            selected: {themeConfig.contrastLevel},
            onSelectionChanged: (Set<ContrastLevel> newSelection) {
              notifier.setContrastLevel(newSelection.first);
            },
          ),
          const SizedBox(height: 24),
          Text('Tint Color', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ...Colors.primaries.map((color) {
                // ignore: deprecated_member_use
                final isSelected = themeConfig.seedColor.value == color.value;
                return GestureDetector(
                  onTap: () {
                    notifier.setSeedColor(color);
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(
                              color: Theme.of(context).colorScheme.onSurface,
                              width: 3,
                            )
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}