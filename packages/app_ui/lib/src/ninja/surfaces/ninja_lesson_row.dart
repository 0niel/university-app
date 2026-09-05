import 'dart:async';

import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/ninja/surfaces/ninja_pill_button.dart';
import 'package:app_ui/src/ninja/surfaces/ninja_progress_bar.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

enum LessonRowState {
  plain,
  past,
  current,
  next,
  moved,
  cancelled,
  exam,
  own;

  static const LessonRowState custom = LessonRowState.own;
}

class NinjaLessonRow extends StatelessWidget {
  const NinjaLessonRow({
    required this.title,
    required this.time,
    super.key,
    this.endTime,
    this.meta,
    this.color,
    this.typeLabel,
    this.chipLabel,
    this.chipColor,
    this.past = false,
    this.current = false,
    this.state,
    this.progress,
    this.stateLabel,
    this.actions = const <NinjaLessonAction>[],
    this.annotations = const <Widget>[],
    this.onTap,
    this.onLongPress,
    this.onMore,
    this.inset = AppSpacing.screen,
    this.outerVerticalInset = AppSpacing.xs,
    this.scheduleStyle = false,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.sectionGap,
    ),
  });

  final String title;
  final String time;
  final String? endTime;
  final String? meta;
  final Color? color;
  final String? typeLabel;
  final String? chipLabel;
  final Color? chipColor;
  final bool past;
  final bool current;
  final LessonRowState? state;
  final double? progress;
  final String? stateLabel;
  final List<NinjaLessonAction> actions;
  final List<Widget> annotations;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onMore;
  final double inset;
  final double outerVerticalInset;
  final bool scheduleStyle;
  final EdgeInsets padding;

  LessonRowState get _state {
    final state = this.state;
    if (state != null) return state;
    if (current) return LessonRowState.current;
    if (past) return LessonRowState.past;
    return LessonRowState.plain;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final state = _state;
    final accent = switch (state) {
      LessonRowState.past => colors.surface2,
      LessonRowState.moved => colors.warn,
      LessonRowState.cancelled || LessonRowState.exam => colors.exam,
      LessonRowState.own => colors.ink,
      _ => color ?? colors.accent,
    };
    final cardColor = switch (state) {
      LessonRowState.current => colors.tint,
      LessonRowState.exam => colors.examTint,
      _ => colors.surface,
    };
    final titleColor = switch (state) {
      LessonRowState.past => colors.muted2,
      LessonRowState.cancelled => colors.muted,
      _ => colors.ink,
    };
    final metaColor = switch (state) {
      LessonRowState.past => colors.muted2,
      LessonRowState.moved => colors.warn,
      LessonRowState.cancelled => colors.danger,
      _ => colors.muted,
    };
    final strike = state == LessonRowState.cancelled
        ? TextDecoration.lineThrough
        : TextDecoration.none;

    final chip = chipLabel;
    final metaText = meta;
    final typeLabel = this.typeLabel;
    final endTime = this.endTime;
    final progress = this.progress;
    final stateLabel = this.stateLabel;

    Widget row = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: inset,
        vertical: outerVerticalInset,
      ),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(AppRadius.row),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 44 *
                    (MediaQuery.textScalerOf(context).scale(14) / 14)
                        .clamp(1.0, 2.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      time,
                      style: AppText.time.copyWith(
                        color: titleColor,
                        decoration: strike,
                      ),
                    ),
                    if (endTime != null)
                      Text(
                        endTime,
                        style: AppText.timeEnd.copyWith(color: metaColor),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sectionGap),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(AppRadius.xxs),
                ),
                child: const SizedBox(width: AppSpacing.xs),
              ),
              const SizedBox(width: AppSpacing.sectionGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (typeLabel != null ||
                        chip != null ||
                        annotations.isNotEmpty)
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.xs,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          if (typeLabel != null)
                            Text(
                              typeLabel,
                              style: AppText.typeTag.copyWith(color: accent),
                            ),
                          if (chip != null)
                            Text(
                              chip,
                              style: AppText.micro.copyWith(
                                color: chipColor ?? colors.muted,
                              ),
                            ),
                          ...annotations,
                        ],
                      ),
                    if (typeLabel != null ||
                        chip != null ||
                        annotations.isNotEmpty)
                      const SizedBox(height: AppSpacing.xs),
                    Text(
                      title,
                      style: (scheduleStyle
                              ? AppText.sans(16, FontWeight.w600)
                              : AppText.headline)
                          .copyWith(
                        color: titleColor,
                        height: 1.25,
                        decoration: strike,
                      ),
                    ),
                    if (metaText != null) ...[
                      SizedBox(height: scheduleStyle ? 5 : 4),
                      Text(
                        metaText,
                        style: (scheduleStyle
                                ? AppText.sans(13, FontWeight.w400)
                                : AppText.subtext)
                            .copyWith(color: metaColor),
                      ),
                    ],
                    if (progress != null) ...[
                      const SizedBox(height: AppSpacing.gap),
                      NinjaProgressBar(
                        value: progress,
                        height: 4,
                        trackColor: colors.surface,
                      ),
                    ],
                    if (actions.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          for (final action in actions)
                            NinjaPillButton(
                              label: action.label,
                              onPressed: action.onPressed,
                              height: 40,
                              horizontalPadding: 14,
                              tone: action.primary
                                  ? NinjaPillTone.primary
                                  : NinjaPillTone.secondary,
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (onMore != null) ...[
                const SizedBox(width: AppSpacing.gap),
                Align(
                  alignment:
                      scheduleStyle ? Alignment.topCenter : Alignment.center,
                  child: Transform.translate(
                    offset: Offset(0, scheduleStyle ? -4 : 0),
                    child: AppPressable(
                      onTap: onMore,
                      semanticsButton: true,
                      child: SizedBox.square(
                        dimension: AppControlSize.touchTarget,
                        child: Center(
                          child: Container(
                            width: 36,
                            height: 36,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: scheduleStyle ? null : colors.surface2,
                              shape: BoxShape.circle,
                            ),
                            child: AppLineIconWidget(
                              AppLineIcon.more,
                              size: AppIconSize.compact,
                              color: colors.muted,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ] else if (stateLabel != null) ...[
                const SizedBox(width: AppSpacing.gap),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 52),
                    child: Text(
                      stateLabel,
                      textAlign: TextAlign.end,
                      style: AppText.micro.copyWith(color: colors.muted2),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (onTap != null || onLongPress != null) {
      row = Semantics(
        button: true,
        label: '$title, $time',
        child: AppPressable(
          onTap: onTap,
          onLongPress: onLongPress == null
              ? null
              : () {
                  unawaited(HapticFeedback.mediumImpact());
                  onLongPress!();
                },
          child: row,
        ),
      );
    }
    return row;
  }
}

class NinjaLessonAction {
  const NinjaLessonAction({
    required this.label,
    this.onPressed,
    this.primary = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool primary;
}

typedef AppLessonRow = NinjaLessonRow;

typedef AppLessonAction = NinjaLessonAction;
