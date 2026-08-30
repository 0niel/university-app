import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

const _kPastelTrack = Color(0x8CFFFFFF);

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
    final colors = context.ninja;
    final target = value.clamp(0.0, 1.0);
    final bar = ClipRRect(
      borderRadius: BorderRadius.circular(NinjaRadius.pill),
      child: SizedBox(
        height: 8,
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: target),
          duration: NinjaMotion.of(context, NinjaMotion.slow),
          curve: NinjaMotion.enter,
          builder: (context, animated, _) => Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(color: pastel ? _kPastelTrack : colors.surfaceAlt),
              FractionallySizedBox(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: animated.clamp(0.0, 1.0),
                child: ColoredBox(
                  color: pastel ? colors.onAccentSoft : colors.brand,
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
      style: NinjaText.tabular(
        NinjaText.microLabel.copyWith(
          color: pastel ? colors.onAccentSoft : colors.mutedDark,
        ),
      ),
    );
    if (MediaQuery.textScalerOf(context).scale(1) >= 1.5) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [bar, const SizedBox(height: 6), text],
      );
    }
    return Row(
      children: [
        Expanded(child: bar),
        const SizedBox(width: 10),
        text,
      ],
    );
  }
}
