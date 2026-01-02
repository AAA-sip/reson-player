// ignore_for_file: always_specify_types

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../service/audio_service.dart';
import '../service/permission_service.dart';

final audioServiceProvider = Provider<AudioService>((_) => AudioService());

final permissionServiceProvider = Provider<PermissionService>((_) => PermissionService());
