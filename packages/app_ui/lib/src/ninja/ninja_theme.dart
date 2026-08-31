import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/theme/theme.dart';
import 'package:flutter/material.dart';

abstract final class NinjaTheme {
  static ThemeData light() =>
      AppTheme.generateTheme(AppColors.light, Brightness.light);

  static ThemeData dark() =>
      AppTheme.generateTheme(AppColors.dark, Brightness.dark);
}
