import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'localization_sync_service.dart';
import 'media_store_service.dart';
import 'tolgee_service.dart';

final mediaStoreServiceProvider = Provider<MediaStoreService>((ref) => MediaStoreServiceImpl());

final tolgeeServiceProvider = Provider<TolgeeService>((ref) => tolgeeService);

/// One-shot per session check for translation updates.
final localizationSyncProvider = FutureProvider<bool>((ref) => LocalizationSyncService.revalidate());
