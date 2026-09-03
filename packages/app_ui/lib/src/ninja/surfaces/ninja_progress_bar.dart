import 'package:app_ui/src/colors/colors.dart';
import 'package:flutter/widgets.dart';

enum NinjaProgressTone { lime, scarlet, ink, lecture, warn }

class NinjaProgressBar extends StatelessWidget {
  const NinjaProgressBar({
    required this.value,
    super.key,
    this.tone = NinjaProgressTone.lime,
    this.height = 6,
    this.color,
    this.trackColor,
  });

  final double value;
  final NinjaProgressTone tone;
  final double height;
  final Color? color;
  final Color? trackColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fill = color ??
        switch (tone) {
          NinjaProgressTone.lime => colors.accent,
          NinjaProgressTone.scarlet => colors.danger,
          NinjaProgressTone.ink => colors.ink,
          NinjaProgressTone.lecture => colors.lecture,
          NinjaProgressTone.warn => colors.warn,
        };
    final radius = BorderRadius.circular(height / 2);

    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: ColoredBox(color: trackColor ?? colors.surface2),
            ),
            FractionallySizedBox(
              alignment: AlignmentDirectional.centerStart,
              widthFactor: value.clamp(0.0, 1.0),
              child: DecoratedBox(
                decoration: BoxDecoration(color: fill, borderRadius: radius),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

typedef AppProgressBar = NinjaProgressBar;
