import 'package:app_ui/src/colors/colors.dart';
import 'package:flutter/widgets.dart';

abstract final class AppSurfaceStyle {
  static Border outline(BuildContext context) {
    final colors = context.colors;
    final highContrast = MediaQuery.highContrastOf(context);
    return Border.all(
      color: colors.ink.withValues(
        alpha: highContrast ? .38 : .07,
      ),
      width: highContrast ? 1.25 : .6,
    );
  }
}
