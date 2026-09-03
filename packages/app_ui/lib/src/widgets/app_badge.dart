import 'dart:math' as math;

import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:flutter/widgets.dart';

enum AppBadgeTone {
  accent,
  ink,
  exam,
  warn,
  lecture,
  lab,
  practice,
  neutral,
}

class AppBadge extends StatelessWidget {
  const AppBadge({
    required this.label,
    super.key,
    this.tone = AppBadgeTone.neutral,
    this.dot = false,
    this.icon,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.badgeInset,
      vertical: AppSpacing.fine,
    ),
    this.textStyle,
  });

  final String label;
  final AppBadgeTone tone;
  final bool dot;
  final AppLineIcon? icon;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final (:bg, :fg) = _resolve(context.colors);
    final icon = this.icon;
    final tinted = tone != AppBadgeTone.accent &&
        tone != AppBadgeTone.ink &&
        tone != AppBadgeTone.neutral;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            AppDot(size: 6, color: fg),
            const SizedBox(width: AppSpacing.xsm),
          ] else if (icon != null) ...[
            AppLineIconWidget(
              icon,
              size: AppIconSize.xxs,
              color: fg,
              strokeWidth: 2.2,
            ),
            const SizedBox(width: AppSpacing.fine),
          ],
          Flexible(
            child: Text(
              label,
              style: (textStyle ?? AppText.badge).copyWith(
                color: textStyle?.color ??
                    (dot && tinted ? context.colors.ink : fg),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ({Color bg, Color fg}) _resolve(AppColors c) => switch (tone) {
        AppBadgeTone.accent => (bg: c.accent, fg: c.onAccent),
        AppBadgeTone.ink => (bg: c.ink, fg: c.canvas),
        AppBadgeTone.exam => (bg: c.examTint, fg: c.exam),
        AppBadgeTone.warn => (bg: c.warnTint, fg: c.warn),
        AppBadgeTone.lecture => (bg: c.lectureTint, fg: c.lecture),
        AppBadgeTone.lab => (bg: c.labTint, fg: c.lab),
        AppBadgeTone.practice => (bg: c.practiceTint, fg: c.practice),
        AppBadgeTone.neutral => (bg: c.surface2, fg: c.muted),
      };
}

class AppCountBadge extends StatelessWidget {
  const AppCountBadge(this.count, {super.key, this.max = 99});

  final int count;
  final int max;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      height: math.max<double>(
        22,
        MediaQuery.textScalerOf(context).scale(11.5) *
            (AppText.badge.height ?? 1.3),
      ),
      constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
      padding: EdgeInsets.symmetric(
        horizontal: count > max ? AppSpacing.compactGap : AppSpacing.xsm,
      ),
      decoration: BoxDecoration(
        color: colors.danger,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Center(
        widthFactor: 1,
        heightFactor: 1,
        child: Text(
          count > max ? '$max+' : '$count',
          style: AppText.badge.copyWith(color: colors.white),
        ),
      ),
    );
  }
}

class AppDot extends StatelessWidget {
  const AppDot({super.key, this.size = 10, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? context.colors.danger,
        shape: BoxShape.circle,
      ),
      child: SizedBox.square(dimension: size),
    );
  }
}

class AppTypeTag extends StatelessWidget {
  const AppTypeTag(this.label, {super.key, this.color});

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tone = color ?? colors.accent;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.gap,
        vertical: AppSpacing.xsm,
      ),
      decoration: BoxDecoration(
        color: colors.tintOf(tone),
        borderRadius: BorderRadius.circular(AppRadius.checkbox),
      ),
      child: Text(
        label,
        style: AppText.microBold.copyWith(
          color: tone,
          letterSpacing: 11 * .04,
        ),
      ),
    );
  }
}
