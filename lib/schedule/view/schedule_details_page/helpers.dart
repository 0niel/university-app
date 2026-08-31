part of '../schedule_details_page.dart';

final List<String> _reactionOrder = [
  for (final type in ReactionType.values) type.name,
];

final Map<String, String> _reactionEmoji = {
  for (final type in ReactionType.values) type.name: type.emoji,
};

bool _sameDate(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

DateTime _atLessonTime(DateTime date, TimeOfDay time) {
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

_LessonRuntime _lessonRuntime(LessonSchedulePart lesson, DateTime date) {
  final now = DateTime.now();
  final start = _atLessonTime(date, lesson.lessonBells.startTime);
  final end = _atLessonTime(date, lesson.lessonBells.endTime);
  final live = now.isAfter(start) && now.isBefore(end);
  final past = now.isAfter(end);
  final total = math.max(1, end.difference(start).inMinutes);
  final elapsed = now.difference(start).inMinutes.clamp(0, total);

  return _LessonRuntime(
    live: live,
    past: past,
    progress: live ? elapsed / total : (past ? 1 : 0),
  );
}

String _lessonTypeName(AppLocalizations l10n, LessonSchedulePart lesson) {
  return LessonCard.getLessonTypeName(l10n, lesson.lessonType);
}

String _timeRange(LessonSchedulePart lesson) {
  return '${lesson.lessonBells.startTime} → ${lesson.lessonBells.endTime}';
}

String _teacherLine(LessonSchedulePart lesson) {
  return lesson.teachers.map((teacher) => teacher.name).join(', ');
}

String _classroomLine(AppLocalizations l10n, LessonSchedulePart lesson) {
  return lesson.classrooms.firstOrNull?.name ??
      l10n.lessonDetailsRoomNotSpecified;
}

String _materialTypeLabel(AppLocalizations l10n, LessonMaterialType type) {
  return switch (type) {
    .note => l10n.lessonDetailsTypeNote,
    .board => l10n.lessonDetailsTypeBoard,
    .task => l10n.lessonDetailsTypeTask,
    .extra => l10n.lessonDetailsTypeExtra,
  };
}

String _formatFileSize(AppLocalizations l10n, int bytes) {
  if (bytes <= 0) return l10n.lessonDetailsFile;
  if (bytes < 1024 * 1024) return '${(bytes / 1024).round()} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}

String _relativeWhen(AppLocalizations l10n, DateTime date) {
  final delta = DateTime.now().difference(date);
  if (delta.inMinutes < 1) return l10n.lessonDetailsJustNow;
  if (delta.inHours < 1) return l10n.lessonDetailsMinutesShort(delta.inMinutes);
  if (delta.inHours < 24) return l10n.lessonDetailsHoursShort(delta.inHours);
  if (delta.inDays == 1) return l10n.lessonDetailsYesterday;
  return DateFormat('dd.MM').format(date);
}
