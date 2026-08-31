import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:flutter/widgets.dart';

class NinjaProgressBar extends StatelessWidget {
  const NinjaProgressBar({
    required this.value,
    super.key,
    this.tone = NinjaProgressTone.lime,
    this.height = 5,
  });
  final double value;
  final NinjaProgressTone tone;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final Color fill;
    switch (tone) {
      case NinjaProgressTone.lime:
        fill = colors.brand;
      case NinjaProgressTone.scarlet:
        fill = colors.scarlet;
      case NinjaProgressTone.ink:
        fill = colors.ink;
    }
    final radius = BorderRadius.circular(height * 0.6);

    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            Positioned.fill(child: ColoredBox(color: colors.surface)),
            FractionallySizedBox(
              alignment: AlignmentDirectional.centerStart,
              widthFactor: value.clamp(0.0, 1.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: radius,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum NinjaProgressTone {
  lime,
  scarlet,
  ink,
}
