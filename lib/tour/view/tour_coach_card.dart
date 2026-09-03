import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

enum TourCoachArrow { none, up, down }

class TourCoachCard extends StatelessWidget {
  const TourCoachCard({
    required this.title,
    required this.body,
    required this.nextLabel,
    required this.onNext,
    this.progress,
    this.backLabel,
    this.onBack,
    this.skipLabel,
    this.onSkip,
    this.arrow = TourCoachArrow.none,
    this.arrowOffset = 0,
    super.key,
  });

  final String title;
  final String body;
  final String nextLabel;
  final VoidCallback onNext;
  final String? progress;
  final String? backLabel;
  final VoidCallback? onBack;
  final String? skipLabel;
  final VoidCallback? onSkip;
  final TourCoachArrow arrow;
  final double arrowOffset;

  static const double tailSize = 10;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final progress = this.progress;
    final skipLabel = this.skipLabel;
    final backLabel = this.backLabel;
    final onSkip = this.onSkip;
    final onBack = this.onBack;
    final secondary = colors.canvas.withValues(alpha: 0.72);

    final card = DecoratedBox(
      decoration: BoxDecoration(
        color: colors.ink,
        borderRadius: BorderRadius.circular(AppRadius.iconTile),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (progress != null || (skipLabel != null && onSkip != null))
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    if (progress != null)
                      Text(
                        progress.toUpperCase(),
                        style: AppText.overline.copyWith(color: colors.accent),
                      ),
                    const Spacer(),
                    if (skipLabel != null && onSkip != null)
                      _TextAction(
                        label: skipLabel,
                        color: secondary,
                        onTap: onSkip,
                      ),
                  ],
                ),
              ),
            Text(
              title,
              style: AppText.headline.copyWith(color: colors.canvas),
            ),
            const SizedBox(height: 4),
            Text(
              body,
              style: AppText.subtext.copyWith(color: secondary, height: 1.4),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                if (backLabel != null && onBack != null) ...[
                  _TextAction(
                    label: backLabel,
                    color: colors.canvas,
                    onTap: onBack,
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: AppPressable(
                    onTap: onNext,
                    semanticsButton: true,
                    semanticsLabel: nextLabel,
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colors.accent,
                        borderRadius: BorderRadius.circular(AppRadius.tile),
                      ),
                      child: Text(
                        nextLabel,
                        style: AppText.label.copyWith(color: colors.onAccent),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (arrow == TourCoachArrow.none) return card;

    final tail = Padding(
      padding: EdgeInsets.only(
        left: math.max(0, arrowOffset - tailSize / 2),
      ),
      child: Transform.rotate(
        angle: math.pi / 4,
        child: Container(
          width: tailSize,
          height: tailSize,
          color: colors.ink,
        ),
      ),
    );
    final tailSlot = SizedBox(
      height: tailSize / 2,
      child: OverflowBox(
        maxHeight: tailSize,
        alignment: arrow == TourCoachArrow.up
            ? Alignment.bottomLeft
            : Alignment.topLeft,
        child: tail,
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (arrow == TourCoachArrow.up) tailSlot,
        card,
        if (arrow == TourCoachArrow.down) tailSlot,
      ],
    );
  }
}

class _TextAction extends StatelessWidget {
  const _TextAction({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      semanticsButton: true,
      semanticsLabel: label,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 40, minWidth: 44),
        child: Center(
          child: Text(label, style: AppText.label.copyWith(color: color)),
        ),
      ),
    );
  }
}
