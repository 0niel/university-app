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
    final colors = context.ninja;
    final l10n = context.l10n;
    final accent = LessonCard.colorOf(lesson);
    final timeRange =
        '${lesson.lessonBells.startTime} - ${lesson.lessonBells.endTime}';

    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: .circular(NinjaRadius.card),
      ),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 8,
        children: [
          Row(
            spacing: 9,
            children: [
              Container(
                width: NinjaMetrics.subjectBarWidthCompact,
                height: 14,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: .circular(NinjaRadius.pill),
                ),
              ),
              Text(
                l10n.addedClass,
                style: NinjaText.subtext.copyWith(color: colors.muted),
              ),
            ],
          ),
          Text(
            lesson.subject,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: NinjaText.headline.copyWith(color: colors.ink),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ScheduleSelectorInfoChip(
                label: LessonCard.getLessonTypeName(l10n, lesson.lessonType),
                color: accent,
                icon: AppLineIcon.book,
              ),
              ScheduleSelectorInfoChip(
                label: timeRange,
                color: colors.brand,
                icon: AppLineIcon.clock,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
