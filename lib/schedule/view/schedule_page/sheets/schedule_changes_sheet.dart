import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/notifications/cubit/notifications_cubit.dart';
import 'package:rtu_mirea_app/notifications/model/notification_feed.dart';
import 'package:rtu_mirea_app/notifications/view/schedule_changes_read_scope.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_status.dart';
import 'package:schedule_repository/schedule_repository.dart';

Future<void> showScheduleChangesSheet(
  BuildContext context, {
  required DateTime weekOf,
}) {
  final cubit = context.read<ScheduleChangesCubit>();
  final notifications = context.read<NotificationsCubit>();
  return showAppSheet<void>(
    context,
    title: context.l10n.changesTitle,
    subtitle: context.l10n.scheduleChangesSubtitleWeek,
    child: MultiBlocProvider(
      providers: [
        BlocProvider.value(value: cubit),
        BlocProvider.value(value: notifications),
      ],
      child: _Changes(weekOf: weekOf),
    ),
  );
}

class _Changes extends StatelessWidget {
  const _Changes({required this.weekOf});
  final DateTime weekOf;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<ScheduleChangesCubit>().state;
    final changes = changesInWeek(state.changes, weekOf);
    return ScheduleChangesReadScope(
      changes: changes,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (state.status == ScheduleChangesStatus.loading && changes.isEmpty)
            const AppSkeletonGroup(
              child: Column(children: [AppSkeletonRow(), AppSkeletonRow()]),
            )
          else if (state.status == ScheduleChangesStatus.failure &&
              changes.isEmpty)
            AppErrorState.compact(title: l10n.scheduleLoadError)
          else if (changes.isEmpty)
            AppEmptyState(
              title: l10n.changesEmptyTitle,
              subtitle: l10n.changesEmptySubtitle,
            )
          else
            AppListGroup(
              children: [
                for (final change in changes)
                  AppListRow(
                    title: change.subject,
                    strong: true,
                    leading: AppBadge(
                      label: _label(l10n, change.kind),
                      tone: switch (change.kind) {
                        ScheduleChangeKind.cancel => AppBadgeTone.exam,
                        ScheduleChangeKind.add => AppBadgeTone.lecture,
                        ScheduleChangeKind.teacher => AppBadgeTone.accent,
                        _ => AppBadgeTone.warn,
                      },
                    ),
                    subtitle: [
                      DateFormat(
                        'E d MMM',
                        Localizations.localeOf(context).toString(),
                      ).format(change.lessonDate),
                      if (change.newValue.start != null) change.newValue.start!,
                      if (change.kind == ScheduleChangeKind.teacher)
                        [
                          change.oldValue.teachers.join(', '),
                          change.newValue.teachers.join(', '),
                        ].join(' → ')
                      else if (change.oldValue.rooms.isNotEmpty ||
                          change.newValue.rooms.isNotEmpty)
                        [
                          change.oldValue.rooms.join(', '),
                          change.newValue.rooms.join(', '),
                        ].join(' → '),
                    ].join(' · '),
                  ),
              ],
            ),
          const SizedBox(height: AppSpacing.sectionGap),
          AppButton.primary(
            label: l10n.scheduleChangesAck,
            size: AppButtonSize.large,
            expanded: true,
            onPressed: () {
              context.read<NotificationsCubit>().markAllRead(
                changes.map(scheduleChangeNotificationId),
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  String _label(AppLocalizations l10n, ScheduleChangeKind kind) =>
      switch (kind) {
        ScheduleChangeKind.cancel => l10n.scheduleChangeTagCancelled,
        ScheduleChangeKind.add => l10n.scheduleChangeTagNew,
        ScheduleChangeKind.teacher => l10n.scheduleChangeTagTeacher,
        ScheduleChangeKind.room => l10n.scheduleChangeTagRoom,
        ScheduleChangeKind.move => l10n.scheduleChangeTagMoved,
      };
}
