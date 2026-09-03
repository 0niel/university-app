import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/home/view/home_day_lessons.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/widgets/lesson_card.dart';
import 'package:schedule_repository/schedule_repository.dart';

String homeGreeting(AppLocalizations l10n, DateTime now) => now.hour < 12
    ? l10n.homeGreetingMorning
    : now.hour < 18
    ? l10n.homeGreetingDay
    : l10n.homeGreetingEvening;

String homeLessonMeta(AppLocalizations l10n, HomeLessonEntry entry) => [
  LessonCard.getLessonTypeName(l10n, entry.lesson.lessonType),
  if (entry.room.isNotEmpty) entry.room,
  if (entry.teacher.isNotEmpty) entry.teacher,
].join(' · ');

String homeLessonRowMeta(AppLocalizations l10n, HomeLessonEntry entry) {
  final type = LessonCard.getLessonTypeName(l10n, entry.lesson.lessonType);
  if (entry.isCancelled) return l10n.lessonMetaCancelled;
  if (entry.isMoved) {
    return l10n.homeLessonMoved(type, entry.room, entry.movedFrom!);
  }
  return [
    type,
    if (entry.room.isNotEmpty) entry.room,
    if (entry.isPast) l10n.lessonMetaPast,
  ].join(' · ');
}

String homeStatusLabel(
  AppLocalizations l10n,
  List<HomeLessonEntry> entries,
  HomeHeroKind kind,
) {
  final active = entries.where((entry) => !entry.isCancelled).toList();
  final entry = homeHeroEntry(entries, kind);
  if (entry == null || active.isEmpty) return l10n.homeStatusNoLessons;
  final count = l10n.lessonsCount(active.length);
  final start = DateFormat.Hm().format(entry.start);
  return switch (kind) {
    HomeHeroKind.during => l10n.homeStatusOngoing(
      active.indexOf(entry) + 1,
      active.length,
    ),
    HomeHeroKind.done => l10n.homeStatusDone,
    HomeHeroKind.before => '$count · ${l10n.homeStatusFirst(start)}',
    HomeHeroKind.pause => '$count · ${l10n.homeStatusNext(start)}',
    HomeHeroKind.other => '$count · ${l10n.homeStatusStart(start)}',
    HomeHeroKind.free => l10n.homeStatusNoLessons,
  };
}

String homeDeadlineLeft(
  AppLocalizations l10n,
  Deadline deadline,
  DateTime now,
) {
  if (deadline.isDone) return l10n.homeDeadlineDone;
  final left = deadline.timeLeftAt(now);
  if (left.isNegative) return l10n.homeOverdue;
  if (left.inHours >= 24) return l10n.homeDaysShort((left.inHours / 24).ceil());
  if (left.inMinutes >= 60) {
    return l10n.homeHoursShort((left.inMinutes / 60).ceil());
  }
  return l10n.homeInMinutes((left.inSeconds / 60).ceil());
}

String homeDeadlineMeta(
  AppLocalizations l10n,
  Deadline deadline,
  DateTime now,
) {
  final due = deadline.dueAt;
  final date = DateUtils.isSameDay(due, now)
      ? l10n.homeDueToday(DateFormat.Hm().format(due))
      : DateUtils.isSameDay(due, now.add(const Duration(days: 1)))
      ? l10n.homeDueTomorrow(DateFormat.Hm().format(due))
      : DateFormat.MMMd(l10n.localeName).add_Hm().format(due);
  return [
    if (deadline.subjectName.isNotEmpty) deadline.subjectName,
    date,
  ].join(' · ');
}

HomeLessonEntry? homeNextExam(List<SchedulePart> schedule, DateTime now) {
  final entries =
      [
          for (final lesson in schedule.whereType<LessonSchedulePart>())
            if (lesson.lessonType == LessonType.exam ||
                lesson.lessonType == LessonType.credit)
              for (final date in lesson.dates)
                ...homeDayEntries(day: date, lessons: [lesson], now: now),
        ].where((entry) => entry.end.isAfter(now)).toList()
        ..sort((a, b) => a.start.compareTo(b.start));
  return entries.firstOrNull;
}
