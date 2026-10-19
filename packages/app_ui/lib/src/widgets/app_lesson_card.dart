import 'dart:async';

import 'package:app_ui/src/animations/ninja_motion.dart';
import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/glass/app_glass_surface.dart';
import 'package:app_ui/src/ninja/surfaces/ninja_lesson_row.dart';
import 'package:app_ui/src/ninja/surfaces/ninja_progress_bar.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

part 'lesson_time.dart';

class AppLessonCard extends StatelessWidget {
  const AppLessonCard({
    required this.title,
    required this.time,
    required this.color,
    this.endTime,
    this.location,
    this.meta,
    this.typeLabel,
    this.chipLabel,
    this.chipColor,
    this.state = LessonRowState.plain,
    this.progress,
    this.icon = AppLineIcon.book,
    this.annotations = const [],
    this.onTap,
    this.onLongPress,
    super.key,
  });

  final String title;
  final String time;
  final String? endTime;
  final String? location;
  final String? meta;
  final String? typeLabel;
  final String? chipLabel;
  final Color color;
  final Color? chipColor;
  final LessonRowState state;
  final double? progress;
  final AppLineIcon icon;
  final List<Widget> annotations;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subdued = state == LessonRowState.past;
    final cancelled = state == LessonRowState.cancelled;
    final live = state == LessonRowState.current;
    final accent = cancelled
        ? colors.danger
        : state == LessonRowState.moved
        ? colors.warn
        : subdued
        ? colors.muted
        : color;
    final foreground = subdued || cancelled ? colors.muted : colors.ink;
    return AppPressable(
      onTap: onTap,
      semanticsButton: onTap != null || onLongPress != null,
      onLongPress: onLongPress == null
          ? null
          : () {
              unawaited(HapticFeedback.mediumImpact());
              onLongPress!();
            },
      child: AnimatedContainer(
        duration: NinjaMotion.of(context),
        curve: NinjaMotion.enter,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.row),
        ),
        child: AppGlassSurface(
          borderRadius: AppRadius.row,
          tone: live ? AppGlassTone.regular : AppGlassTone.subtle,
          tint: accent,
          child: Stack(
            children: [
              PositionedDirectional(
                start: 0,
                top: AppSpacing.md,
                bottom: AppSpacing.md,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: subdued ? .4 : 1),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: const SizedBox(width: AppSpacing.micro),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(14, 12, 12, 12),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final largeText =
                        MediaQuery.textScalerOf(context).scale(1) > 1.4;
                    final stacked = constraints.maxWidth < 230 || largeText;
                    final timeBlock = _LessonTime(
                      start: time,
                      end: endTime,
                      foreground: foreground,
                      horizontal: stacked,
                    );
                    final details = Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          maxLines: largeText ? null : 2,
                          overflow: largeText
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                          style: AppText.heading.copyWith(
                            color: foreground,
                            decoration: cancelled
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        if (typeLabel != null ||
                            chipLabel != null ||
                            location != null) ...[
                          const SizedBox(height: AppSpacing.xsm),
                          Wrap(
                            spacing: AppSpacing.xsm,
                            runSpacing: AppSpacing.xs,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              if (typeLabel case final label?)
                                _LessonBadge(
                                  label: label,
                                  color: accent,
                                  icon: icon,
                                ),
                              if (location case final room?)
                                _LessonMetadata(
                                  text: room,
                                  icon: AppLineIcon.pin,
                                  color: foreground,
                                ),
                              if (chipLabel case final label?)
                                _LessonBadge(
                                  label: label,
                                  color: chipColor ?? accent,
                                ),
                            ],
                          ),
                        ],
                        if (meta case final description?) ...[
                          const SizedBox(height: AppSpacing.xs),
                          _LessonMetadata(
                            text: description,
                            icon: AppLineIcon.people,
                            maxLines: largeText || state == LessonRowState.moved
                                ? null
                                : 1,
                            color: state == LessonRowState.moved
                                ? colors.warn
                                : colors.muted,
                          ),
                        ],
                        if (progress case final value?) ...[
                          const SizedBox(height: AppSpacing.sm),
                          NinjaProgressBar(
                            value: value,
                            color: accent,
                            height: 3,
                            trackColor: accent.withValues(alpha: .12),
                          ),
                        ],
                        if (annotations.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.xsm),
                          Wrap(
                            spacing: AppSpacing.xsm,
                            runSpacing: AppSpacing.xs,
                            children: annotations,
                          ),
                        ],
                      ],
                    );
                    return stacked
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              timeBlock,
                              const SizedBox(height: AppSpacing.sm),
                              details,
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConstrainedBox(
                                constraints: const BoxConstraints(minWidth: 46),
                                child: timeBlock,
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(child: details),
                            ],
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
