import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/shared_pref/shared_pref_keys.dart';
import '../utils/shared_pref/shared_pref_manager.dart';

enum AppStyle { material, cupertino }

class AppStyleController extends Notifier<AppStyle> {
  //
  @override
  AppStyle build() {
    final styleIndex = SharedPrefManager.getData<int>(AppPrefKey.appStyle);

    return styleIndex != null ? AppStyle.values[styleIndex] : AppStyle.material;
  }

  Future<void> setStyle(AppStyle style) async {
    if (state == style) return;

    state = style;

    await SharedPrefManager.saveData(AppPrefKey.appStyle, style.index);
  }
}

final appStyleControllerProvider = NotifierProvider<AppStyleController, AppStyle>(AppStyleController.new);
