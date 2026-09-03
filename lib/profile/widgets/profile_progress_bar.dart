import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

class ProfileProgressBar extends StatelessWidget {
  const ProfileProgressBar({
    required this.value,
    super.key,
    this.label,
    this.pastel = false,
  });

  final double value;
  final String? label;
  final bool pastel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final target = value.clamp(0.0, 1.0);
    final bar = ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: SizedBox(
        height: 8,
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: target),
          duration: NinjaMotion.of(context, NinjaMotion.slow),
          curve: NinjaMotion.enter,
          builder: (context, animated, _) => Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(
                color: pastel ? colors.white.withAlpha(140) : colors.surface2,
              ),
              FractionallySizedBox(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: animated.clamp(0.0, 1.0),
                child: ColoredBox(
                  color: pastel ? colors.ink : colors.accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final label = this.label;
    if (label == null) return bar;
    final text = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppText.captionSmall
          .copyWith(
            color: pastel ? colors.ink : colors.muted,
          )
          .copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
    );
    if (MediaQuery.textScalerOf(context).scale(1) >= 1.5) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          bar,
          const SizedBox(height: AppSpacing.xsm),
          text,
        ],
      );
    }
    return Row(
      children: [
        Expanded(child: bar),
        const SizedBox(width: AppSpacing.gap),
        text,
      ],
    );
  }
}
