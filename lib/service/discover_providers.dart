import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'media_store_service.dart';

final mediaStoreServiceProvider = Provider<MediaStoreService>(
  (ref) => MediaStoreServiceImpl(),
);
