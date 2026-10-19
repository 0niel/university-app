import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/design_preview/fixtures/preview_fixtures.dart';
import 'package:rtu_mirea_app/design_preview/widgets/preview_lesson_sheet.dart';
import 'package:rtu_mirea_app/design_preview/widgets/preview_page.dart';
import 'package:rtu_mirea_app/design_preview/widgets/preview_text_sheet.dart';
import 'package:rtu_mirea_app/home/view/home_day_lessons.dart';
import 'package:rtu_mirea_app/home/view/home_labels.dart';
import 'package:rtu_mirea_app/home/view/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class PreviewHomePage extends StatelessWidget {
  const PreviewHomePage({required this.onTab, super.key});

  final ValueChanged<int> onTab;

  @override
  Widget build(BuildContext context) => _PreviewHomeContent(onTab: onTab);
}

class _PreviewHomeContent extends StatefulWidget {
  const _PreviewHomeContent({required this.onTab});

  final ValueChanged<int> onTab;

  @override
  State<_PreviewHomeContent> createState() => _PreviewHomeContentState();
}

class _PreviewHomeContentState extends State<_PreviewHomeContent> {
  DateTime _day = PreviewFixtures.now;
  final _notes = <String, String>{};

  Future<void> _editNote(HomeLessonEntry entry) async {
    final note = await showAppSheet<String>(
      context,
      title: context.l10n.lessonDetailsNote,
      child: PreviewTextSheet(
        label: entry.lesson.subject,
        initialValue: _notes[entry.lesson.subject] ?? '',
      ),
    );
    if (note != null && mounted) {
      setState(() => _notes[entry.lesson.subject] = note);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final now = PreviewFixtures.now;
    final days = homeWeekDays(_day);
    final entries = homeDayEntries(
      day: _day,
      lessons: homeLessonsForDay(PreviewFixtures.lessons, _day),
      now: now,
    );
    final kind = homeHeroKind(
      entries: entries,
      isToday: DateUtils.isSameDay(_day, now),
    );
    return PreviewPage(
      children: [
        Row(
          children: [
            AppPressable(
              onTap: () => widget.onTab(4),
              semanticsLabel: l10n.navProfile,
              child: const AppAvatar(name: PreviewFixtures.name, size: 46),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: HomeClockPill(now: now, dotColor: context.colors.accent),
              ),
            ),
          ],
        ),
        HomeGreeting(
          greeting: homeGreeting(l10n, now),
          name: PreviewFixtures.name.split(' ').firstOrNull ?? '',
          subtitle: homeStatusLabel(l10n, entries, kind),
        ),
        PreviewPageRail(
          child: HomeWeekPills(
            days: days,
            selectedIndex: days.indexWhere(
              (day) => DateUtils.isSameDay(day, _day),
            ),
            today: now,
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
        HomeSectionReveal(
          child: HomeHero(
            entries: entries,
            kind: kind,
            tomorrow: homeLessonsForDay(
              PreviewFixtures.lessons,
              now.add(const Duration(days: 1)),
            ),
            now: now,
            deadline: PreviewFixtures.deadlines.firstOrNull,
            onOpen: (entry) => unawaited(showPreviewLesson(context, entry)),
            onRoute: (_) => widget.onTab(2),
            onNote: (entry) => unawaited(_editNote(entry)),
            onFreeRooms: () => widget.onTab(2),
            onDeadlines: () => widget.onTab(3),
            onTomorrow: () =>
                setState(() => _day = now.add(const Duration(days: 1))),
          ),
        ),
        HomeLessonsGroup(
          entries: entries,
          featuredEntry: homeHeroEntry(entries, kind),
          onOpen: (entry) => unawaited(showPreviewLesson(context, entry)),
        ),
        PreviewPageRail(
          child: HomeStatusStrip(
            deadlines: PreviewFixtures.deadlines,
            profile: PreviewFixtures.profile,
            now: now,
            onProfile: () => widget.onTab(4),
            onDeadlines: () => widget.onTab(3),
            onExam: () => widget.onTab(1),
          ),
        ),
      ],
    );
  }
}
