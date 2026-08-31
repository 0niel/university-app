part of '../schedule_page.dart';

class _LessonProgressBar extends StatelessWidget {
  const _LessonProgressBar({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return ExcludeSemantics(
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: .circular(NinjaRadius.pill),
              child: SizedBox(
                height: 8,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: value.clamp(0, 1)),
                  duration: NinjaMotion.of(context, NinjaMotion.slow),
                  curve: NinjaMotion.enter,
                  builder: (context, animated, _) => Stack(
                    fit: .expand,
                    children: [
                      ColoredBox(color: Colors.white.withValues(alpha: .55)),
                      FractionallySizedBox(
                        alignment: .centerLeft,
                        widthFactor: animated.clamp(0, 1),
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
            '${(value.clamp(0, 1) * 100).round()}%',
            style: NinjaText.tabular(
              NinjaText.microLabel.copyWith(color: colors.onAccentSoft),
            ),
          ),
        ],
      ),
    );
  }
}
