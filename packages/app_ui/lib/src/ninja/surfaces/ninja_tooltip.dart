import 'dart:math' as math;

import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_icon_tile.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

enum NinjaTooltipArrow { up, down }

class NinjaTooltip extends StatelessWidget {
  const NinjaTooltip({
    required this.message,
    super.key,
    this.arrow = NinjaTooltipArrow.up,
    this.arrowInset = 22,
  });

  final String message;
  final NinjaTooltipArrow arrow;
  final double arrowInset;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tail = Transform.rotate(
      angle: math.pi / 4,
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: colors.ink,
          borderRadius: BorderRadius.circular(AppRadius.xxs),
        ),
      ),
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        PositionedDirectional(
          start: arrowInset,
          top: arrow == NinjaTooltipArrow.up ? -5 : null,
          bottom: arrow == NinjaTooltipArrow.down ? -5 : null,
          child: tail,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.ink,
            borderRadius: BorderRadius.circular(AppRadius.iconTile),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Text(
              message,
              style: AppText.subtextStrong.copyWith(color: colors.canvas),
            ),
          ),
        ),
      ],
    );
  }
}

class NinjaFeatureHint extends StatelessWidget {
  const NinjaFeatureHint({
    required this.title,
    required this.body,
    super.key,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final action = actionLabel;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sectionGap),
      decoration: BoxDecoration(
        color: colors.tint,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconTile(
            icon: AppLineIcon.spark,
            background: colors.tint2,
            foreground: colors.accent,
            iconSize: AppIconSize.action,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: AppText.label.copyWith(color: colors.ink)),
                const SizedBox(height: AppSpacing.micro),
                Text(
                  body,
                  style: AppText.subtext.copyWith(color: colors.muted),
                ),
                if (action != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  AppPressable(
                    onTap: onAction,
                    semanticsLabel: action,
                    semanticsButton: true,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 44),
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          action,
                          style: AppText.subtextBold.copyWith(
                            color: colors.accent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
