import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/strings.g.dart';
import '../../../../core/localization/supported_locales.dart';

Future<void> showLanguagePicker(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (_) => const LanguagePickerWidget(),
  );
}

class LanguagePickerWidget extends StatelessWidget {
  const LanguagePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final current = context.locale;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: Text(Strings.languagePicker.title, style: theme.textTheme.titleMedium),
          ),
          for (final locale in supportedLocales)
            ListTile(
              title: Text(localeDisplayName(locale)),
              trailing: locale.languageCode == current.languageCode
                  ? Icon(Icons.check, color: theme.colorScheme.primary)
                  : null,
              onTap: () {
                Navigator.pop(context);
                if (locale.languageCode != current.languageCode) {
                  context.setLocale(locale);
                }
              },
            ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
