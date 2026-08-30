part of 'home_lesson_hero.dart';

class _HeroProgress extends StatelessWidget {
  const _HeroProgress({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: .circular(NinjaRadius.pill),
            child: SizedBox(
              height: 8,
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: progress),
                duration: NinjaMotion.of(context, NinjaMotion.slow),
                curve: NinjaMotion.enter,
                builder: (context, value, _) => Stack(
                  fit: .expand,
                  children: [
                    ColoredBox(color: Colors.white.withValues(alpha: .55)),
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: value.clamp(0.0, 1.0),
                      child: ColoredBox(color: colors.onAccentSoft),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '${(progress * 100).round()}%',
          style: NinjaText.tabular(
            NinjaText.microLabel.copyWith(color: colors.onAccentSoft),
          ),
        ),
      ],
    );
  }
}
