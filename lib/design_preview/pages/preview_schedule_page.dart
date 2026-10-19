import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/design_preview/fixtures/preview_fixtures.dart';
import 'package:rtu_mirea_app/design_preview/widgets/preview_lesson_sheet.dart';
import 'package:rtu_mirea_app/design_preview/widgets/preview_page.dart';
import 'package:rtu_mirea_app/home/view/home_day_lessons.dart';
import 'package:rtu_mirea_app/home/view/widgets/home_week_pills.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_text.dart';

class PreviewSchedulePage extends StatefulWidget {
  const PreviewSchedulePage({super.key});

  @override
  State<PreviewSchedulePage> createState() => _PreviewSchedulePageState();
}

class _PreviewSchedulePageState extends State<PreviewSchedulePage> {
  DateTime _day = PreviewFixtures.now;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final days = homeWeekDays(_day);
    final entries = homeDayEntries(
      day: _day,
      lessons: homeLessonsForDay(PreviewFixtures.lessons, _day),
      now: PreviewFixtures.now,
    );
    return PreviewPage(
      children: [
        NinjaDisplayHeader(
          title: l10n.schedule,
          summary: PreviewFixtures.group,
          padding: EdgeInsets.zero,
        ),
        PreviewPageRail(
          child: HomeWeekPills(
            days: days,
            selectedIndex: days.indexWhere(
              (day) => DateUtils.isSameDay(day, _day),
            ),
            today: PreviewFixtures.now,
            lessonCounts: [
              for (final day in days)
                homeLessonsForDay(PreviewFixtures.lessons, day).length,
            ],
            changedDays: const {},
            onSelected: (index) {
              final selectedDay = days.elementAtOrNull(index);
              if (selectedDay != null) setState(() => _day = selectedDay);
            },
            onWeekChanged: (offset) =>
                setState(() => _day = _day.add(Duration(days: offset * 7))),
            onLessonCountForDay: (day) =>
                homeLessonsForDay(PreviewFixtures.lessons, day).length,
          ),
        ),
        if (entries.isEmpty)
          AppEmptyState(
            title: l10n.scheduleFreeDayTitle,
            lineIcon: AppLineIcon.calendar,
          ),
        for (final entry in entries)
          AppLessonCard(
            title: entry.lesson.subject,
            time: DateFormat.Hm().format(entry.start),
            endTime: DateFormat.Hm().format(entry.end),
            color: lessonAccentOf(context, entry.lesson),
            location: entry.room,
            meta: entry.teacher,
            typeLabel: lessonShortLabel(l10n, entry.lesson.lessonType),
            chipLabel: entry.isCurrent
                ? l10n.homeHeroNow
                : entry.isNext
                ? l10n.homeNextTag
                : null,
            state: entry.isCurrent
                ? LessonRowState.current
                : entry.isPast
                ? LessonRowState.past
                : LessonRowState.plain,
            progress: entry.isCurrent
                ? PreviewFixtures.now.difference(entry.start).inSeconds /
                      entry.end.difference(entry.start).inSeconds
                : null,
            onTap: () => unawaited(showPreviewLesson(context, entry)),
          ),
      ],
    );
  }
}
