import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reson/core/localization/localization_loader.dart';
import 'package:reson/core/utils/shared_pref/_export.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('bundled en.json resolves through LocalizationLoader when delegates are registered', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await SharedPrefManager.init();
    await EasyLocalization.ensureInitialized();

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const <Locale>[Locale('en'), Locale('ru')],
        path: 'assets/local',
        fallbackLocale: const Locale('en'),
        assetLoader: const LocalizationLoader(),
        child: Builder(
          builder: (context) => MaterialApp(
            locale: context.locale,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            home: Scaffold(body: Text('settings.title'.tr())),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('settings.title'), findsNothing);
  });
}
