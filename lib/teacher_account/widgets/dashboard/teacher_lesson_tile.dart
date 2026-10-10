import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_text.dart';
import 'package:rtu_mirea_app/teacher_account/domain/teacher_workload.dart';
import 'package:schedule_repository/schedule_repository.dart';

class TeacherLessonTile extends StatelessWidget {
  const TeacherLessonTile({
    required this.occurrence,
    required this.now,
    required this.onTap,
    this.isNext = false,
    this.showDate = false,
    super.key,
  });

  final TeacherLessonOccurrence occurrence;
  final DateTime now;
  final VoidCallback onTap;
  final bool isNext;
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final past = !now.isBefore(occurrence.end);
    final live = !now.isBefore(occurrence.start) && !past;
    final state = occurrence.isCancelled
        ? LessonRowState.cancelled
        : past
        ? LessonRowState.past
        : live
        ? LessonRowState.current
        : isNext
        ? LessonRowState.next
        : (occurrence.lesson.lessonType == LessonType.exam ||
              occurrence.lesson.lessonType == LessonType.credit)
        ? LessonRowState.exam
        : LessonRowState.plain;
    final meta = [
      if (showDate) DateFormat.MMMEd(l10n.localeName).format(occurrence.date),
      lessonTypeName(l10n, occurrence.lesson.lessonType),
      if (occurrence.lesson.classrooms.isNotEmpty)
        occurrence.lesson.classrooms.map(classroomLabel).join(', '),
      if (occurrence.groups.isNotEmpty)
        occurrence.groups.map((group) => group.name).join(', '),
      if (occurrence.isCancelled) l10n.lessonMetaCancelled,
      if (past && !occurrence.isCancelled) l10n.lessonMetaPast,
    ].join(' · ');
    return AppLessonRow(
      key: ValueKey((occurrence.start, occurrence.lesson)),
      title: occurrence.lesson.subject,
      time: DateFormat.Hm().format(occurrence.start),
      endTime: DateFormat.Hm().format(occurrence.end),
      meta: meta,
      state: state,
      color: lessonAccentOf(context, occurrence.lesson),
      typeLabel: lessonShortLabel(l10n, occurrence.lesson.lessonType),
      chipLabel: occurrence.isCancelled
          ? l10n.lessonTagCancelled
          : live
          ? l10n.lessonTagLive(occurrence.end.difference(now).inMinutes)
          : isNext
          ? l10n.lessonTagNext
          : null,
      chipColor: occurrence.isCancelled
          ? context.colors.danger
          : context.colors.accent,
      progress: live && !occurrence.isCancelled
          ? (now.difference(occurrence.start).inSeconds /
                    occurrence.duration.inSeconds)
                .clamp(0, 1)
                .toDouble()
          : null,
      inset: 0,
      outerVerticalInset: 0,
      scheduleStyle: true,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.fieldGap,
        AppSpacing.lg,
        AppSpacing.xsm,
        AppSpacing.lg,
      ),
      onTap: onTap,
    );
  }
}
