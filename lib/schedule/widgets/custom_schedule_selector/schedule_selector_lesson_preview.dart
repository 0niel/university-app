import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/widgets/custom_schedule_selector/schedule_selector_info_chip.dart';
import 'package:rtu_mirea_app/schedule/widgets/lesson_card.dart';
import 'package:schedule_repository/schedule_repository.dart';

class ScheduleSelectorLessonPreview extends StatelessWidget {
  const ScheduleSelectorLessonPreview({required this.lesson, super.key});

  final LessonSchedulePart lesson;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final accent = LessonCard.colorOfFor(context, lesson);
    final timeRange =
        '${lesson.lessonBells.startTime} - ${lesson.lessonBells.endTime}';

    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        color: colors.surface2,
        borderRadius: .circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: .start,
        spacing: AppSpacing.sm,
        children: [
          Row(
            spacing: 9,
            children: [
              Container(
                width: 4,
                height: 14,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: .circular(AppRadius.full),
                ),
              ),
              Text(
                l10n.addedClass,
                style: AppText.subtext.copyWith(color: colors.muted),
              ),
            ],
          ),
          Text(
            lesson.subject,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppText.headline.copyWith(color: colors.ink),
          ),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              ScheduleSelectorInfoChip(
                label: LessonCard.getLessonTypeName(l10n, lesson.lessonType),
                color: accent,
                icon: AppLineIcon.book,
              ),
              ScheduleSelectorInfoChip(
                label: timeRange,
                color: colors.accent,
                icon: AppLineIcon.clock,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
