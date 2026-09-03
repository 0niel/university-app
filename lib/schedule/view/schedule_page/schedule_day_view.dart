import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/day_timeline.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_status.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_text.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_dates.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_day_strip.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_overlap_switcher.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets.dart';
import 'package:schedule_repository/schedule_repository.dart';

class ScheduleDayView extends StatelessWidget {
  const ScheduleDayView({
    required this.day,
    required this.schedule,
    required this.changes,
    required this.preferences,
    required this.display,
    required this.activities,
    required this.comparing,
    required this.onDay,
    this.showDayStrip = true,
    this.now,
    super.key,
  });

  final DateTime day;
  final List<SchedulePart> schedule;
  final List<ScheduleChange> changes;
  final SchedulePreferencesState preferences;
  final ScheduleDisplayState display;
  final List<UserActivity> activities;
  final bool comparing;
  final ValueChanged<DateTime> onDay;
  final DateTime? now;
  final bool showDayStrip;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final now = this.now ?? DateTime.now();
    final lessons = applyPreferences(lessonsForDay(schedule, day), preferences);
    final timeline = buildDayTimeline(
      lessons: lessons,
      changes: changes,
      day: day,
      now: now,
      showPast: display.showPast,
      showCancelled: display.showCancelled,
      showGaps: preferences.showGaps && !comparing,
    );
    final own =
        activities
            .where(
              (a) =>
                  isSameDate(a.startsAt, day) &&
                  (display.showPast ||
                      (a.endsAt ?? a.startsAt.add(const Duration(hours: 1)))
                          .isAfter(now)),
            )
            .toList()
          ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
    final rows = <(DateTime, DateTime, Widget, List<(DateTime, DateTime)>)>[
      for (final group in groupTimelineLessons(timeline.entries))
        (
          atTime(day, group.first.lesson.lessonBells.startTime),
          group
              .map((entry) => atTime(day, entry.lesson.lessonBells.endTime))
              .reduce((a, b) => a.isAfter(b) ? a : b),
          ScheduleOverlapSwitcher(
            key: ValueKey(
              'schedule-overlap-${group.first.lesson.lessonBells.startTime}',
            ),
            labels: [for (final entry in group) entry.lesson.subject],
            initialIndex: group
                .indexWhere(
                  (entry) => entry.status.live && !entry.cancelled,
                )
                .clamp(0, group.length - 1),
            colors: [
              for (final entry in group) lessonAccentOf(context, entry.lesson),
            ],
            children: [
              for (final entry in group)
                ScheduleTimelineLesson(entry: entry, day: day),
            ],
          ),
          [
            for (final entry in group)
              if (!entry.cancelled)
                (
                  atTime(day, entry.lesson.lessonBells.startTime),
                  atTime(day, entry.lesson.lessonBells.endTime),
                ),
          ],
        ),
      for (final activity in own)
        (
          activity.startsAt,
          activity.endsAt ?? activity.startsAt.add(const Duration(hours: 1)),
          AppLessonRow(
            outerVerticalInset: 0,
            scheduleStyle: true,
            title: activity.title,
            time: DateFormat.Hm(locale).format(activity.startsAt),
            endTime: activity.endsAt == null
                ? null
                : DateFormat.Hm(locale).format(activity.endsAt!),
            typeLabel:
                activity.subtitle ?? activityTypeLabel(l10n, activity.type),
            meta: activity.place,
            color: context.colors.ink,
            state: LessonRowState.own,
            inset: 0,
          ),
          [
            (
              activity.startsAt,
              activity.endsAt ??
                  activity.startsAt.add(const Duration(hours: 1)),
            ),
          ],
        ),
      for (final event in schedule.whereType<CalendarSchedulePart>())
        if (event.dates.any((date) => isSameDate(date, day)) &&
            !event.isAllDay &&
            event.startsAt != null &&
            (display.showPast ||
                (event.endsAt ?? event.startsAt!.add(const Duration(hours: 1)))
                    .isAfter(now)))
          (
            event.startsAt!,
            event.endsAt ?? event.startsAt!.add(const Duration(hours: 1)),
            AppLessonRow(
              outerVerticalInset: 0,
              scheduleStyle: true,
              title: event.title,
              time: DateFormat.Hm(locale).format(event.startsAt!),
              endTime: event.endsAt == null
                  ? null
                  : DateFormat.Hm(locale).format(event.endsAt!),
              typeLabel: l10n.activityTypeEvent,
              meta: [
                if (event.location != null) event.location!,
                if (event.description != null) event.description!,
              ].join(' · '),
              color: context.colors.accent,
              state: LessonRowState.own,
              inset: 0,
            ),
            [
              (
                event.startsAt!,
                event.endsAt ?? event.startsAt!.add(const Duration(hours: 1)),
              ),
            ],
          ),
    ]..sort((a, b) => a.$1.compareTo(b.$1));
    final currentIndex = rows.indexWhere(
      (row) => row.$4.any(
        (interval) => !now.isBefore(interval.$1) && now.isBefore(interval.$2),
      ),
    );
    final nextIndex = rows.indexWhere(
      (row) => row.$4.any((interval) => interval.$1.isAfter(now)),
    );
    final showNow =
        isSameDate(day, now) &&
        now.hour * 60 + now.minute >= 540 &&
        now.hour * 60 + now.minute <= 1170;
    final nowLine = ScheduleNowLine(
      label: DateFormat.Hm(locale).format(now),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showDayStrip) ...[
          ScheduleDayStrip(
            day: day,
            now: now,
            schedule: schedule,
            preferences: preferences,
            display: display,
            changes: changes,
            onDay: onDay,
          ),
          const SizedBox(height: AppSpacing.contentGap),
        ],
        LayoutBuilder(
          builder: (context, constraints) {
            final title = Text(
              isSameDate(day, now)
                  ? l10n.today
                  : capitalizeFirst(
                      DateFormat('EEEE, d', locale).format(day),
                    ),
              style: AppText.section.copyWith(color: context.colors.ink),
            );
            Widget nav(
              String label,
              VoidCallback action, {
              bool accent = false,
            }) => AppPressable(
              onTap: action,
              semanticsLabel: label,
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: AppControlSize.touchTarget,
                  minWidth: AppControlSize.touchTarget,
                ),
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: AppText.label.copyWith(
                    color: accent
                        ? context.colors.accent
                        : context.colors.muted,
                  ),
                ),
              ),
            );
            final navigation = Wrap(
              spacing: AppSpacing.xsm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                nav(
                  l10n.schedulePrevWeek,
                  () => onDay(day.subtract(const Duration(days: 7))),
                ),
                nav(l10n.todayLower, () => onDay(now), accent: true),
                nav(
                  l10n.scheduleNextWeek,
                  () => onDay(day.add(const Duration(days: 7))),
                ),
                Text(
                  l10n.scheduleDayLessons(timeline.totalLessons),
                  style: AppText.sans(
                    13,
                    FontWeight.w500,
                  ).copyWith(color: context.colors.muted),
                ),
              ],
            );
            return constraints.maxWidth < 330 ||
                    MediaQuery.textScalerOf(context).scale(1) > 1.3
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [title, navigation],
                  )
                : SizedBox(
                    height: AppSpacing.section,
                    child: OverflowBox(
                      minHeight: AppControlSize.touchTarget,
                      maxHeight: 44,
                      child: Row(
                        children: [
                          Expanded(child: title),
                          const SizedBox(width: AppSpacing.sm),
                          navigation,
                        ],
                      ),
                    ),
                  );
          },
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        for (final part in schedule)
          if (part.dates.any((date) => isSameDate(date, day)) &&
              (part is HolidaySchedulePart ||
                  (part is CalendarSchedulePart &&
                      (part.isAllDay || part.startsAt == null))))
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: AppBanner(
                message: part is HolidaySchedulePart
                    ? part.title
                    : (part as CalendarSchedulePart).title,
              ),
            ),
        if (rows.isEmpty)
          AppEmptyState(
            title: timeline.totalLessons == 0
                ? l10n.scheduleFreeDayTitle
                : l10n.emptyFilterTitle(
                    l10n.scheduleLessonsLabel.toLowerCase(),
                  ),
            subtitle: timeline.totalLessons == 0
                ? l10n.scheduleFreeDaySubtitle
                : l10n.filtersHiddenHint,
            actionLabel: timeline.totalLessons == 0
                ? l10n.add
                : l10n.filtersTitle,
            onAction: () => timeline.totalLessons == 0
                ? showAddLessonSheet(context, day: day)
                : showScheduleFilterSheet(context, day: day),
          )
        else
          Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  for (var index = 0; index < rows.length; index++) ...[
                    if (index > 0) const SizedBox(height: AppSpacing.sm),
                    if (index > 0 && preferences.showGaps && !comparing)
                      ..._gap(
                        context,
                        rows
                            .take(index)
                            .map((row) => row.$2)
                            .reduce(
                              (a, b) => a.isAfter(b) ? a : b,
                            ),
                        rows[index].$1,
                      ),
                    if (showNow && currentIndex < 0 && nextIndex == index)
                      nowLine,
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        rows[index].$3,
                        if (showNow && currentIndex == index)
                          Positioned(
                            left: -8,
                            right: -8,
                            top: 0,
                            child: IgnorePointer(
                              child: nowLine,
                            ),
                          ),
                      ],
                    ),
                  ],
                  if (showNow && currentIndex < 0 && nextIndex < 0) nowLine,
                ],
              ),
            ],
          ),
      ],
    );
  }

  List<Widget> _gap(
    BuildContext context,
    DateTime before,
    DateTime after,
  ) {
    final minutes = after.difference(before).inMinutes;
    return minutes > 15
        ? [
            AppGapRow(text: context.l10n.scheduleBreakMinutes(minutes)),
            const SizedBox(height: AppSpacing.sm),
          ]
        : [];
  }
}

class ScheduleNowLine extends StatelessWidget {
  const ScheduleNowLine({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          decoration: BoxDecoration(
            color: context.colors.canvas,
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: Text(
            label,
            style: AppText.sans(
              10,
              FontWeight.w800,
              tabular: true,
            ).copyWith(color: context.colors.danger),
          ),
        ),
        const SizedBox(width: AppSpacing.xsm),
        Expanded(
          child: Container(
            key: const ValueKey('schedule-now-line'),
            height: AppSpacing.xxs,
            decoration: BoxDecoration(
              color: context.colors.danger,
              borderRadius: BorderRadius.circular(AppRadius.hairline),
            ),
          ),
        ),
      ],
    ),
  );
}

class ScheduleTimelineLesson extends StatelessWidget {
  const ScheduleTimelineLesson({
    required this.entry,
    required this.day,
    super.key,
  });

  final ScheduleLessonEntry entry;
  final DateTime day;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lesson = entry.lesson;
    final status = entry.status;
    final type = lessonTypeName(l10n, lesson.lessonType);
    final meta = [
      if (entry.cancelled)
        l10n.lessonMetaCancelled
      else if (entry.moved && entry.previousRoom != null)
        l10n.lessonMetaMoved(
          type,
          entry.movedRoom ?? singleClassroomText(l10n, lesson),
          entry.previousRoom!,
        )
      else ...[
        type,
        singleClassroomText(l10n, lesson),
        if (status.past) l10n.lessonMetaPast,
      ],
      if (lesson.teachers.isNotEmpty)
        lesson.teachers.map((teacher) => teacher.name).join(', '),
    ].join(' · ');
    final state = entry.cancelled
        ? LessonRowState.cancelled
        : status.past
        ? LessonRowState.past
        : status.live
        ? LessonRowState.current
        : entry.moved
        ? LessonRowState.moved
        : entry.isNext
        ? LessonRowState.next
        : (lesson.lessonType == LessonType.exam ||
              lesson.lessonType == LessonType.credit)
        ? LessonRowState.exam
        : LessonRowState.plain;
    return AppLessonRow(
      outerVerticalInset: 0,
      scheduleStyle: true,
      title: lesson.subject,
      time: '${lesson.lessonBells.startTime}',
      endTime: '${lesson.lessonBells.endTime}',
      state: state,
      color: lessonAccentOf(context, lesson),
      typeLabel: lessonShortLabel(l10n, lesson.lessonType),
      chipLabel: entry.cancelled
          ? l10n.lessonTagCancelled
          : status.live
          ? l10n.lessonTagLive(status.minutesLeft)
          : entry.moved
          ? l10n.lessonTagMoved
          : entry.isNext
          ? l10n.lessonTagNext
          : entry.isNew
          ? l10n.lessonTagNew
          : null,
      chipColor: entry.cancelled
          ? context.colors.danger
          : entry.moved
          ? context.colors.warn
          : context.colors.accent,
      meta: meta,
      progress: status.live && !entry.cancelled ? status.progress : null,
      inset: 0,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.fieldGap,
        AppSpacing.lg,
        AppSpacing.xsm,
        AppSpacing.lg,
      ),
      onTap: () =>
          ScheduleDetailsRoute($extra: (lesson, day)).push<void>(context),
      onLongPress: () =>
          showLessonActionsSheet(context, lesson: lesson, day: day),
    );
  }
}
