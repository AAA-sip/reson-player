# UI Reson

## Принцип

Material Design 3. Кастомизация через seed color и контраст.

## Тема

- **Шрифт**: RobotoFlex (variable font)
- **Генерация**: `flex_seed_scheme` — цвета из seed color
- **Контраст**: 3 уровня — normal, medium, high
- **Режим**: system / light / dark

```dart
// core/theme/theme_generator.dart
generateTheme(brightness: Brightness.light, config: themeConfig)
```

## Naming виджетов

| Тип | Паттерн | Пример |
|-----|---------|--------|
| Экран | `<feature>_screen.dart` | `home_screen.dart` |
| Секция | `<feature>_<section>_section.dart` | `home_tracks_section.dart` |
| Виджет | `<descriptive>_widget.dart` | `tile_widget.dart` |
| Appbar | `<feature>_appbar.dart` | `home_appbar.dart` |

## Структура экрана

```
ui/material/<feature>/
├── <feature>_screen.dart      # Экран (StatelessWidget)
├── <feature>_state.dart       # Провайдеры состояния
└── widgets/                   # Виджеты экрана (в одной папке)
    ├── <section>_section.dart
    └── <widget>_widget.dart
```

## Правила

1. **Экран = StatelessWidget**. Логика в state/providers.
2. **Виджеты не знают друг о друге**. Экран собирает их.
3. **Нет StatelessWidget-обёрток ради обёрток**. Если виджет не переиспользуется — inline.
4. **Размеры**: только целые числа, без дробей.
5. **Отступы**: кратны 4 или 8.
