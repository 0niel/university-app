import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/home/view/home_day_lessons.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_sheets.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/cubit/schedule_changes/schedule_changes_cubit.dart';
import 'package:schedule_repository/schedule_repository.dart';

class SettingsWidgetPreview extends StatelessWidget {
  const SettingsWidgetPreview({super.key, this.now});

  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final instant = now ?? DateTime.now();
    final schedule =
        context.watch<ScheduleBloc>().state.selectedSchedule?.schedule ??
        const <SchedulePart>[];
    final changes =
        context.watch<ScheduleChangesCubit?>()?.state.changes ??
        const <ScheduleChange>[];
    final days = <DateTime>{
      for (final lesson in schedule.whereType<LessonSchedulePart>())
        for (final day in lesson.dates)
          if (!DateTime(
            day.year,
            day.month,
            day.day,
          ).isBefore(DateTime(instant.year, instant.month, instant.day)))
            DateTime(day.year, day.month, day.day),
    }.toList()..sort();
    HomeLessonEntry? next;
    for (final day in days) {
      final entries = homeDayEntries(
        day: day,
        lessons: homeLessonsForDay(schedule, day),
        now: instant,
        changes: changes,
      );
      for (final entry in entries) {
        if (!entry.isCancelled && entry.start.isAfter(instant)) {
          next = entry;
          break;
        }
      }
      if (next != null) break;
    }
    final subtitle = next == null
        ? l10n.settingsWidgetNoLesson
        : l10n.settingsWidgetNext(DateFormat.Hm().format(next.start));
    final title = next == null
        ? l10n.noUpcomingLessons
        : [
            next.lesson.subject,
            if (next.room.isNotEmpty) next.room,
          ].join(' · ');
    return Padding(
      padding: const EdgeInsets.only(top: 13),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: colors.line)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppPressable(
                onTap: () => showWidgetSheet(context),
                semanticsLabel: l10n.settingsLockWidget,
                semanticsButton: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.settingsLockWidget,
                          style: AppText.sans(
                            15,
                            FontWeight.w600,
                            height: 4 / 3,
                          ).copyWith(color: colors.ink),
                        ),
                      ),
                      AppLineIconWidget(.info, color: colors.muted),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.gap),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.canvas,
                  borderRadius: BorderRadius.circular(AppRadius.banner),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sectionGap,
                    vertical: AppSpacing.md,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 36,
                        decoration: BoxDecoration(
                          color: colors.practice,
                          borderRadius: BorderRadius.circular(AppRadius.xxs),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subtitle,
                              style: AppText.sans(
                                11,
                                FontWeight.w700,
                              ).copyWith(color: colors.muted),
                            ),
                            const SizedBox(height: AppSpacing.xxs),
                            Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.sans(
                                14,
                                FontWeight.w700,
                              ).copyWith(color: colors.ink),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        l10n.settingsWidgetPreview,
                        style: AppText.sans(
                          11,
                          FontWeight.w600,
                        ).copyWith(color: colors.muted),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
