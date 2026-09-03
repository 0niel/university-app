import 'package:app_ui/src/colors/colors.dart';
import 'package:flutter/widgets.dart';

class AppXpProgressBar extends StatelessWidget {
  const AppXpProgressBar({
    required this.value,
    super.key,
    this.height = 6,
    this.color,
  });

  final double value;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: colors.surface2),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value.clamp(0.0, 1.0),
              child: ColoredBox(color: color ?? colors.accent),
            ),
          ],
        ),
      ),
    );
  }
}
