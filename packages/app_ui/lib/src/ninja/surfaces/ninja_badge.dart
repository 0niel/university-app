import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:flutter/widgets.dart';

enum NinjaBadgeTone {
  lime,
  ink,
  dangerOutline,
  warnTint,
  successTint,
  labTint,
  practiceTint,
  neutral,
}

class NinjaBadge extends StatelessWidget {
  const NinjaBadge(this.label, {super.key, this.tone = NinjaBadgeTone.lime});

  final String label;
  final NinjaBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (background, foreground, dot) = switch (tone) {
      NinjaBadgeTone.lime => (colors.accent, colors.onAccent, null),
      NinjaBadgeTone.ink => (colors.ink, colors.canvas, null),
      NinjaBadgeTone.dangerOutline => (
          colors.examTint,
          colors.ink,
          colors.danger,
        ),
      NinjaBadgeTone.warnTint => (colors.warnTint, colors.ink, colors.warn),
      NinjaBadgeTone.successTint => (
          colors.lectureTint,
          colors.ink,
          colors.lecture,
        ),
      NinjaBadgeTone.labTint => (colors.labTint, colors.ink, colors.lab),
      NinjaBadgeTone.practiceTint => (
          colors.practiceTint,
          colors.ink,
          colors.practice,
        ),
      NinjaBadgeTone.neutral => (colors.surface2, colors.muted, null),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.badgeInset,
          vertical: AppSpacing.fine,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dot != null) ...[
              DecoratedBox(
                decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
                child: const SizedBox.square(dimension: 6),
              ),
              const SizedBox(width: AppSpacing.xsm),
            ],
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.badge.copyWith(color: foreground),
            ),
          ],
        ),
      ),
    );
  }
}

class NinjaCountBadge extends StatelessWidget {
  const NinjaCountBadge(this.count, {super.key, this.max = 99}) : _dot = false;

  const NinjaCountBadge.dot({super.key})
      : count = 0,
        max = 99,
        _dot = true;

  final int count;
  final int max;
  final bool _dot;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    if (_dot) {
      return DecoratedBox(
        decoration: BoxDecoration(color: colors.danger, shape: BoxShape.circle),
        child: const SizedBox.square(dimension: 10),
      );
    }

    final label = count > max ? '$max+' : '$count';
    return Semantics(
      label: label,
      child: ExcludeSemantics(
        child: Container(
          height: 22,
          constraints: const BoxConstraints(minWidth: 22),
          padding: EdgeInsets.symmetric(
            horizontal:
                label.length > 2 ? AppSpacing.compactGap : AppSpacing.xsm,
          ),
          decoration: BoxDecoration(
            color: colors.danger,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppText.badge.copyWith(color: colors.white),
          ),
        ),
      ),
    );
  }
}
