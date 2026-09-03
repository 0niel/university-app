import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:schedule/schedule.dart';

const kProfileNumberSeparator = ' ';

String profileNumber(int value) {
  final digits = value.abs().toString();
  final buffer = StringBuffer(value < 0 ? '-' : '');
  for (var i = 0; i < digits.length; i++) {
    if (i != 0 && (digits.length - i) % 3 == 0) {
      buffer.write(kProfileNumberSeparator);
    }
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

String rankLabel(AppLocalizations l10n, int xp) => switch (NinjaRank.fromXp(
  xp,
)) {
  NinjaRank.genin => l10n.profileRankShinobi,
  NinjaRank.chunin => l10n.profileRankChunin,
  NinjaRank.jonin => l10n.profileRankJonin,
  NinjaRank.kage => l10n.profileRankKage,
};

String formatGpa(BuildContext context, double gpa) => NumberFormat(
  '0.00',
  Localizations.localeOf(context).toString(),
).format(gpa);

String formatTimeOfDay(TimeOfDay time) {
  final hours = time.hour.toString().padLeft(2, '0');
  final minutes = time.minute.toString().padLeft(2, '0');
  return '$hours:$minutes';
}

const Set<LessonType> kExamLessonTypes = {
  LessonType.exam,
  LessonType.credit,
  LessonType.courseWork,
  LessonType.courseProject,
};

int? daysUntilNextExam(List<SchedulePart> parts, DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  DateTime? nearest;
  for (final part in parts) {
    if (part is! LessonSchedulePart) continue;
    if (!kExamLessonTypes.contains(part.lessonType)) continue;
    for (final date in part.dates) {
      final day = DateTime(date.year, date.month, date.day);
      if (day.isBefore(today)) continue;
      if (nearest == null || day.isBefore(nearest)) nearest = day;
    }
  }
  return nearest?.difference(today).inDays;
}

typedef LessonPreview = ({
  String subject,
  String room,
  TimeOfDay start,
  LessonType type,
});

LessonPreview? nextLessonPreview(List<SchedulePart> parts, DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  DateTime? best;
  LessonSchedulePart? bestPart;
  for (final part in parts) {
    if (part is! LessonSchedulePart) continue;
    final start = part.lessonBells.startTime;
    for (final date in part.dates) {
      final at = DateTime(
        date.year,
        date.month,
        date.day,
        start.hour,
        start.minute,
      );
      if (at.isBefore(now) || at.isBefore(today)) continue;
      if (best == null || at.isBefore(best)) {
        best = at;
        bestPart = part;
      }
    }
  }
  if (bestPart == null) return null;
  return (
    subject: bestPart.subject,
    room: bestPart.classrooms.isEmpty ? '' : bestPart.classrooms.first.name,
    start: bestPart.lessonBells.startTime,
    type: bestPart.lessonType,
  );
}

Color lessonTypeColor(AppColors colors, LessonType type) => switch (type) {
  LessonType.lecture => colors.lecture,
  LessonType.laboratoryWork => colors.lab,
  LessonType.exam ||
  LessonType.credit ||
  LessonType.courseWork ||
  LessonType.courseProject => colors.exam,
  _ => colors.practice,
};
