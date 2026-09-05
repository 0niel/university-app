import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/notifications/cubit/notifications_cubit.dart';
import 'package:rtu_mirea_app/notifications/model/notification_feed.dart';
import 'package:schedule_repository/schedule_repository.dart';

class ScheduleChangesReadScope extends StatelessWidget {
  const ScheduleChangesReadScope({
    required this.changes,
    required this.child,
    super.key,
  });

  final List<ScheduleChange> changes;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationsCubit?>();
    final userId = cubit?.state.userId;
    final ids = changes.map(scheduleChangeNotificationId).toList();
    if (cubit != null && cubit.state.hasUnread(ids)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted &&
            !cubit.isClosed &&
            cubit.state.userId == userId &&
            (ModalRoute.of(context)?.isCurrent ?? true)) {
          cubit.markAllRead(ids);
        }
      });
    }
    return child;
  }
}
