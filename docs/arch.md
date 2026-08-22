# Архитектура Reson

## Принцип

Плоская структура. Минимум слоёв. Никаких абстракций ради абстракций.

## Структура

lib/
├── core/                          # Глобальная логика (theme, route, utils, deps)
│
├── model/                         # Все модели данных проекта
│   ├── song_model.dart
│   ├── album_model.dart
│   ├── artist_model.dart
│   └── playlist_model.dart
│
├── service/                        # Все сервисы и провайдеры
│   ├── media_store_service.dart
│   └── discover_providers.dart
│
└── ui/                             # Весь UI
    ├── material/                   # Material Design тема
    │   ├── discover/               # Экраны и виджеты discover
    │   ├── player/                 # Экраны и виджеты player
    │   ├── search/                 # Экраны и виджеты search
    │   └── settings/               # Экраны и виджеты settings
    └── cupertino/                  # Cupertino тема (опционально)

## Правила

### 1. Model — единственный тип данных

Нет `entity`. `model` используется везде — в service, в state, в UI.

```dart
// model/song_model.dart
class SongModel {
  final int id;
  final String title;
  final String artist;
}
```

### 2. Все модели в одном месте

`lib/model/` — все модели проекта. Не по фичам, а плоско.

### 3. Все сервисы в одном месте

`lib/service/` — все сервисы и их провайдеры. Не по фичам, а плоско.

### 4. Нет слоя repo

Service напрямую отдаёт model. UI state напрямую вызывает service.

```
service.getSongs() → List<SongModel>
         ↓
state (FutureProvider) читает service
         ↓
UI читает state
```

### 5. Service — абстракция источника данных

```dart
// service/media_store_service.dart
abstract class MediaStoreService {
  Future<List<SongModel>> getSongs();
}
```

### 6. UI State — провайдеры

```dart
// ui/material/discover/home_state.dart
final songsProvider = FutureProvider<List<SongModel>>((ref) async {
  final service = ref.read(mediaStoreServiceProvider);
  return service.getSongs();
});
```

### 7. Провайдеры сервисов — в service/

```dart
// service/discover_providers.dart
final mediaStoreServiceProvider = Provider<MediaStoreService>(
  (ref) => MediaStoreServiceImpl(),
);
```

### 8. UI зависит только от model и service

UI-виджеты импортируют модели и сервисы. Не импортируют друг друга между фичами.

### 9. Фичи — только в UI-слое

Логика фичи живёт в `service/` и `model/`. Визуал — в `ui/material/<feature>/`.

## Что убрано

| Было | Стало | Зачем |
|------|-------|-------|
| `src/` | — | Лишний уровень вложенности |
| `features/` | — | Не нужен при плоской структуре |
| `entity/` | — | Дублирует `model/` |
| `repo/` | — | Прокидка без логики |
| `domain/` | — | Провайдеры → `service/` |
| `data/` | — | model и service — на верхнем уровне |
| `controller/` | — | Провайдеры → `service/` |
| model внутри фичи | `lib/model/` | Все модели в одном месте |
| service внутри фичи | `lib/service/` | Все сервисы в одном месте |
| UI внутри фичи | `ui/material/` | Чистое разделение логики и UI |

## Добавление новой фичи

1. Создать экран/виджеты в `ui/material/<feature>/`
2. Если нужны новые модели — в `model/`
3. Если нужны новые сервисы — в `service/`
4. Провайдеры сервиса — в `service/<feature>_providers.dart`
