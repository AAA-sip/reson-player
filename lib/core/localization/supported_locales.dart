import 'dart:ui';

/// Single source of truth for app locales.
const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('ru')];

/// Native self-names, never translated.
const Map<String, String> _localeNames = <String, String>{'en': 'English', 'ru': 'Русский'};

String localeDisplayName(Locale locale) => _localeNames[locale.languageCode] ?? locale.languageCode;
