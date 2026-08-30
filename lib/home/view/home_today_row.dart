import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/widgets/lesson_card.dart';
import 'package:schedule_repository/schedule_repository.dart';

class HomeTodayRow extends StatelessWidget {
  const HomeTodayRow({
    required this.lesson,
    required this.isNext,
    super.key,
    this.isPast = false,
  });

  final LessonSchedulePart lesson;
  final bool isNext;
  final bool isPast;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final accent = isPast
        ? colors.disabledLine
        : LessonCard.getColorByTypeFor(context, lesson.lessonType);
    final l10n = context.l10n;
    final room = _roomLabel(lesson);
    final isExam = lesson.lessonType == .exam || lesson.lessonType == .credit;
    final status = isNext
        ? l10n.homeNextTag
        : isExam
        ? l10n.homeCreditTag
        : null;
    final number = lesson.lessonBells.number;
    final teacher = lesson.teachers.map((item) => item.name).join(', ');
    final typeName = LessonCard.getLessonTypeName(
      l10n,
      lesson.lessonType,
    ).toLowerCase();
    final accessible = MediaQuery.textScalerOf(context).scale(1) >= 1.6;
    final title = isPast ? colors.muted : colors.ink;
    final meta = isPast ? colors.disabled : colors.muted;

    return AppPressable(
      onTap: () => context.go('/schedule'),
      semanticsLabel: '${lesson.subject}, $room',
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(NinjaRadius.card),
        ),
        padding: const .fromLTRB(16, 14, 12, 14),
        child: Row(
          children: [
            SizedBox(
              width: accessible ? 66 : 52,
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    _timeLabel(lesson.lessonBells.startTime),
                    style: NinjaText.tabular(
                      NinjaText.body.copyWith(
                        color: title,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _timeLabel(lesson.lessonBells.endTime),
                    style: NinjaText.tabular(
                      NinjaText.helper.copyWith(color: meta),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: NinjaMetrics.subjectBarWidthCompact,
              height: accessible ? 56 : 40,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: .circular(NinjaRadius.pill),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    lesson.subject,
                    maxLines: accessible ? 3 : 2,
                    overflow: .ellipsis,
                    style: NinjaText.body.copyWith(
                      color: title,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    [
                      if (number != null)
                        l10n.lessonDetailsPairNumber('$number'),
                      typeName,
                      room,
                      if (teacher.isNotEmpty) teacher,
                      ?status,
                    ].join(' · '),
                    maxLines: accessible ? 3 : 2,
                    overflow: .ellipsis,
                    style: NinjaText.helper.copyWith(color: meta),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            AppLineIconWidget(.chevronR, size: 16, color: colors.chevron),
          ],
        ),
      ),
    );
  }
}

String _timeLabel(TimeOfDay time) =>
    DateFormat.Hm().format(DateTime(0, 1, 1, time.hour, time.minute));

String _roomLabel(LessonSchedulePart lesson) => lesson.classrooms.isEmpty
    ? '—'
    : lesson.classrooms.map((classroom) => classroom.name).join(', ');
