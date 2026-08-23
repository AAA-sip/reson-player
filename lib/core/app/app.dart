import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../service/providers.dart';
import 'app_style.dart';
import 'cupertino_app.dart';
import 'material_app.dart';

class ResonApp extends ConsumerWidget {
  const ResonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = ref.watch(appStyleControllerProvider);

    // Translations were refreshed in background -> reload current strings.
    ref.listen<AsyncValue<bool>>(localizationSyncProvider, (_, next) {
      if (next.hasValue && next.value == true) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) context.setLocale(context.locale);
        });
      }
    });

    return switch (style) {
      AppStyle.material => const MaterialResonApp(),
      AppStyle.cupertino => const CupertinoResonApp(),
    };
  }
}
