import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/app/theme/app_color_scheme.dart';

export 'app_color_scheme.dart';

class AppColorSchemes {
  static const AppColorScheme defaultScheme = .blue;

  static const List<AppColorScheme> selectable = [
    .blue,
    .violet,
    .green,
    .red,
  ];

  static AppColors getLightColors(AppColorScheme scheme) {
    return AppColors.light.withAccent(toAccent(scheme));
  }

  static AppColors getDarkColors(AppColorScheme scheme) {
    return AppColors.dark.withAccent(toAccent(scheme));
  }

  static AppAccent toAccent(AppColorScheme scheme) => switch (scheme) {
    .blue => AppAccent.blue,
    .violet => AppAccent.violet,
    .yellow => AppAccent.blue,
    .red => AppAccent.red,
    .green => AppAccent.green,
  };

  static Color getSchemePreviewColor(AppColorScheme scheme) {
    return AppColors.accentColor(toAccent(scheme), isDark: false);
  }

  static List<Color> getSchemePalette(AppColorScheme scheme) {
    final colors = getLightColors(scheme);
    return [colors.accent, colors.tint, colors.onAccent];
  }
}
