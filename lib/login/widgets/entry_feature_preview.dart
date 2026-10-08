import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/widgets/entry_campus_preview.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/day_timeline.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_day_strip.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_day_view.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_header.dart';
import 'package:rtu_mirea_app/services/data/services_directory.dart';
import 'package:rtu_mirea_app/services/view/widgets/service_row.dart';
import 'package:schedule_repository/schedule_repository.dart';

enum EntryFeature { schedule, campus, community }

class EntryFeaturePreview extends StatelessWidget {
  const EntryFeaturePreview({required this.feature, super.key});

  final EntryFeature feature;

  @override
  Widget build(BuildContext context) => AppEntryPreview(
    child: ColoredBox(
      color: context.colors.canvas,
      child: switch (feature) {
        EntryFeature.schedule => const _SchedulePreview(),
        EntryFeature.campus => const EntryCampusPreview(),
        EntryFeature.community => const _CommunityPreview(),
      },
    ),
  );
}

class _SchedulePreview extends StatelessWidget {
  const _SchedulePreview();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final day = DateTime(2026, 9);
    final now = DateTime(2026, 9, 1, 10, 55);
    final lessons = [
      for (final data in [
        (
          l10n.entryPreviewLesson,
          LessonType.lecture,
          10,
          40,
          12,
          10,
          'А-318',
          2,
        ),
        (
          l10n.entryPreviewProgramming,
          LessonType.practice,
          12,
          40,
          14,
          10,
          'И-204',
          3,
        ),
      ])
        LessonSchedulePart(
          subject: data.$1,
          lessonType: data.$2,
          teachers: const [],
          classrooms: [
            Classroom(
              name: data.$7,
              campus: const Campus(name: 'Вернадского, 78', shortName: 'В-78'),
            ),
          ],
          lessonBells: LessonBells(
            startTime: TimeOfDay(hour: data.$3, minute: data.$4),
            endTime: TimeOfDay(hour: data.$5, minute: data.$6),
            number: data.$8,
          ),
          dates: [day],
        ),
    ];
    final timeline = buildDayTimeline(
      lessons: lessons,
      changes: const [],
      day: day,
      now: now,
      showPast: true,
      showCancelled: true,
      showGaps: false,
    );
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          ScheduleHeader(day: day, name: null, topInset: AppSpacing.screenTop),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            child: Column(
              children: [
                ScheduleDayStrip(
                  day: day,
                  now: now,
                  schedule: lessons,
                  preferences: const SchedulePreferencesState(),
                  display: const ScheduleDisplayState(),
                  changes: const [],
                  onDay: (_) {},
                ),
                const SizedBox(height: AppSpacing.lg),
                for (final entry
                    in timeline.entries.whereType<ScheduleLessonEntry>()) ...[
                  ScheduleTimelineLesson(entry: entry, day: day),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommunityPreview extends StatelessWidget {
  const _CommunityPreview();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final entries = ServicesDirectory.community(context);
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppScreenHeader(
            title: l10n.services,
            overline: l10n.servicesSectionCommunity,
            applyTopInset: false,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            child: AppListGroup(
              children: [
                for (final entry in entries.take(4))
                  ServiceRow(entry: entry, onTap: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
