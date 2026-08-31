import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:app_ui/src/ninja/ninja_text.dart';
import 'package:flutter/widgets.dart';

class NinjaBadge extends StatelessWidget {
  const NinjaBadge(this.label, {super.key, this.tone = NinjaBadgeTone.lime});

  final String label;
  final NinjaBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final (background, foreground, accent) = switch (tone) {
      NinjaBadgeTone.lime => (colors.brand, colors.onBrand, null),
      NinjaBadgeTone.ink => (colors.ink, colors.onInk, null),
      NinjaBadgeTone.dangerOutline => (
          colors.dangerTint,
          colors.ink,
          colors.scarlet,
        ),
      NinjaBadgeTone.warnTint => (
          colors.warnTint,
          colors.ink,
          colors.amber,
        ),
      NinjaBadgeTone.successTint => (
          colors.successTint,
          colors.ink,
          colors.green,
        ),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(NinjaRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (accent != null) ...[
              DecoratedBox(
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                ),
                child: const SizedBox.square(dimension: 6),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: NinjaText.microLabel.copyWith(color: foreground),
            ),
          ],
        ),
      ),
    );
  }
}

enum NinjaBadgeTone { lime, ink, dangerOutline, warnTint, successTint }

class NinjaCountBadge extends StatelessWidget {
  const NinjaCountBadge(this.count, {super.key}) : _dot = false;

  const NinjaCountBadge.dot({super.key})
      : count = 0,
        _dot = true;

  final int count;
  final bool _dot;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    if (_dot) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: colors.scarlet,
          shape: BoxShape.circle,
        ),
        child: const SizedBox.square(dimension: 10),
      );
    }

    final label = count > 99 ? '99+' : '$count';
    return Semantics(
      label: label,
      child: ExcludeSemantics(
        child: Container(
          height: 22,
          constraints: const BoxConstraints(minWidth: 22),
          padding: EdgeInsets.symmetric(horizontal: label.length > 2 ? 7 : 6),
          decoration: BoxDecoration(
            color: colors.scarlet,
            borderRadius: BorderRadius.circular(NinjaRadius.pill),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: NinjaText.microLabel.copyWith(color: colors.onScarlet),
          ),
        ),
      ),
    );
  }
}
