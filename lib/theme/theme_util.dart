import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/material.dart';

import 'model/theme_config.dart';

ThemeData themeData(BuildContext context) {
  return Theme.of(context);
}

FlexTones tonesFor(ContrastLevel level, Brightness brightness) {
  switch (level) {
    case ContrastLevel.normal:
      return FlexTones.material(brightness);
    case ContrastLevel.medium:
      return FlexTones.highContrast(brightness);
    case ContrastLevel.high:
      return FlexTones.highContrast(brightness).onMainsUseBW();
  }
}
