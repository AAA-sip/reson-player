# State Management — Riverpod

## Принцип

Всё состояние — через Riverpod. Никакого StatefulWidget для бизнес-логики.

## Типы провайдеров

| Тип | Когда использовать | Пример |
|-----|-------------------|--------|
| `Provider` | Синглтон сервиса | `mediaStoreServiceProvider` |
| `FutureProvider` | Асинхронные данные | `songsProvider` |
| `StateProvider` | Простое значение | `selectedTabProvider` |
| `StateNotifierProvider` | Сложная логика мутации | Пока не используется |

## Naming

| Что | Паттерн | Пример |
|-----|---------|--------|
| Провайдер сервиса | `<service>Provider` | `mediaStoreServiceProvider` |
| Провайдер данных | `<plural>Provider` | `songsProvider`, `albumsProvider` |
| Провайдер UI-состояния | `<feature><State>Provider` | `selectedTabProvider` |

## Где живут провайдеры

| Тип | Расположение |
|-----|-------------|
| Сервисные | `service/<feature>_providers.dart` |
| UI-состояние | `ui/material/<feature>/<feature>_state.dart` |
| Глобальные (shared prefs, audio) | `core/deps/providers.dart` |

## Паттерн: запрос данных

```dart
final songsProvider = FutureProvider<List<SongModel>>((ref) async {
  final service = ref.watch(mediaStoreServiceProvider);
  return service.getSongs();
});
```

UI читает:
```dart
ref.watch(songsProvider).when(
  data: (songs) => ...,
  loading: () => ...,
  error: (e, _) => ...,
);
```

## Правила

1. **`ref.watch`** в build, **`ref.read`** в callbacks.
2. **Провайдеры не знают друг о друге**. Зависимости через `ref.watch`.
3. **Нет бизнес-логики в UI**. Всё в провайдерах/сервисах.
4. **Family** — только для параметризованных запросов (id, page).
