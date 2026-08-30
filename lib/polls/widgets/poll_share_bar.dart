part of 'poll_card.dart';

class _PollShareBar extends StatelessWidget {
  const _PollShareBar({required this.value, required this.highlight});

  final double value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return ClipRRect(
      borderRadius: BorderRadius.circular(NinjaRadius.pill),
      child: SizedBox(
        height: 8,
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: value),
          duration: NinjaMotion.of(context, NinjaMotion.slow),
          curve: NinjaMotion.enter,
          builder: (context, animated, _) => Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(color: colors.surface),
              FractionallySizedBox(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: animated.clamp(0.0, 1.0),
                child: ColoredBox(
                  color: highlight ? colors.brand : colors.chevron,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
