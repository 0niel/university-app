import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

class AppBootPlaceholder extends StatelessWidget {
  const AppBootPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    return ColoredBox(
      color: colors.canvas,
      child: Center(
        child: AppSpinner(
          color: colors.accent,
          trackColor: colors.surface2,
        ),
      ),
    );
  }
}
