import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/teacher_account/bloc/teacher_dashboard_state.dart';
import 'package:rtu_mirea_app/teacher_account/domain/teacher_workload.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/dashboard/teacher_dashboard_targets_section.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/dashboard/teacher_day_schedule.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/dashboard/teacher_metrics.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/dashboard/teacher_schedule_status.dart';
import 'package:schedule_repository/schedule_repository.dart';

class TeacherDashboardScheduleSection extends StatelessWidget {
  const TeacherDashboardScheduleSection({
    required this.state,
    required this.onChangeWeek,
    required this.onToday,
    required this.onSelectDay,
    required this.onRetry,
    required this.onOpenLesson,
    required this.onOpenGroup,
    required this.onOpenRoom,
    super.key,
  });

  final TeacherDashboardState state;
  final ValueChanged<int> onChangeWeek;
  final VoidCallback onToday;
  final ValueChanged<DateTime> onSelectDay;
  final VoidCallback onRetry;
  final ValueChanged<TeacherLessonOccurrence> onOpenLesson;
  final ValueChanged<Group> onOpenGroup;
  final ValueChanged<Classroom> onOpenRoom;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final workload = state.workload;
    final preview = state.preview;
    final dateFormat = DateFormat.MMMd(l10n.localeName);
    final weekEnd = state.week.add(const Duration(days: 6));
    final lessonCount = workload.occurrences
        .where((entry) => !entry.isCancelled)
        .length;
    String duration(Duration value) {
      final hours = value.inHours;
      final minutes = value.inMinutes % 60;
      return [
        if (hours > 0) l10n.homeHoursShort(hours),
        if (minutes > 0 || hours == 0) l10n.minutesShort(minutes),
      ].join(' ');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppOverline(l10n.teacherWeekWorkload),
        Row(
          children: [
            AppIconButton(
              tooltip: l10n.teacherPreviousWeek,
              onPressed: () => onChangeWeek(-1),
              icon: const AppLineIconWidget(AppLineIcon.chevronL),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                '${dateFormat.format(state.week)} – '
                '${dateFormat.format(weekEnd)}',
                textAlign: TextAlign.center,
                style: AppText.headlineStrong.copyWith(color: colors.ink),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            AppIconButton(
              tooltip: l10n.teacherNextWeek,
              onPressed: () => onChangeWeek(1),
              icon: const AppLineIconWidget(AppLineIcon.chevronR),
            ),
          ],
        ),
        if (!DateUtils.isSameDay(state.day, state.now))
          Align(
            child: AppButton.text(label: l10n.today, onPressed: onToday),
          )
        else
          const SizedBox(height: AppSpacing.md),
        if (!state.schedule.hasError && state.schedule.data == null)
          AppSkeletonGroup(
            semanticsLabel: l10n.loadingContent,
            child: const AppSkeleton(height: 160, radius: AppRadius.card),
          )
        else if (state.schedule.hasError && state.schedule.data == null)
          AppErrorState(
            title: l10n.scheduleLoadingError,
            message: l10n.tryAgain,
            primaryLabel: l10n.retry,
            footnote: null,
            onPrimary: onRetry,
          )
        else ...[
          TeacherScheduleStatus(
            resource: state.schedule,
            changes: state.changes,
            onRetry: onRetry,
          ),
          TeacherMetrics(
            metrics: [
              (l10n.teacherLessonCount, '$lessonCount'),
              (l10n.teacherTeachingTime, duration(workload.totalDuration)),
              (
                l10n.teacherWindowTime,
                duration(
                  workload.gaps.fold(
                    Duration.zero,
                    (sum, gap) => sum + gap.duration,
                  ),
                ),
              ),
              (l10n.teacherGroups, '${workload.groups.length}'),
            ],
          ),
          if (workload.occurrences.isEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.teacherWeekNoLessons,
              style: AppText.body.copyWith(color: colors.muted),
            ),
          ],
        ],
        TeacherDaySchedule(
          key: const ValueKey('teacher-dashboard-days'),
          schedule: state.schedule,
          workload: workload,
          week: state.week,
          day: state.day,
          now: state.now,
          preview: preview,
          onSelectDay: onSelectDay,
          onOpenLesson: onOpenLesson,
        ),
        if (state.schedule.data != null)
          TeacherDashboardTargetsSection(
            key: ValueKey(state.query),
            groups: workload.groups,
            rooms: workload.classrooms,
            onOpenGroup: onOpenGroup,
            onOpenRoom: onOpenRoom,
          ),
      ],
    );
  }
}
