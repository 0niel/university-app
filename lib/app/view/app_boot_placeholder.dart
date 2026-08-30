import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

class AppBootPlaceholder extends StatelessWidget {
  const AppBootPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final colors = isDark ? NinjaColors.dark() : NinjaColors.light();
    return ColoredBox(
      color: colors.canvas,
      child: Center(
        child: AppNinjaMark(
          size: 56,
          color: colors.brand,
          spin: !MediaQuery.disableAnimationsOf(context),
        ),
      ),
    );
  }
}
