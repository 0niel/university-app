import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/notifications/cubit/notifications_cubit.dart';
import 'package:rtu_mirea_app/notifications/model/notification_feed.dart';
import 'package:rtu_mirea_app/notifications/view/schedule_changes_read_scope.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_status.dart';
import 'package:rtu_mirea_app/schedule/widgets/schedule_change_card.dart';

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
            for (final change in changes)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.gap),
                child: ScheduleChangeCard(change: change),
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
}
