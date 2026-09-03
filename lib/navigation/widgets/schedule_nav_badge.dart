import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/notifications/cubit/notifications_cubit.dart';
import 'package:rtu_mirea_app/notifications/model/notification_feed.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';

class ScheduleNavBadge extends StatelessWidget {
  const ScheduleNavBadge({required this.builder, super.key});

  final Widget Function(BuildContext context, {required bool hasUnread})
      builder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleChangesCubit, ScheduleChangesState>(
      builder: (context, changes) {
        final ids = changes.changes.map(scheduleChangeNotificationId);
        return BlocBuilder<NotificationsCubit, NotificationsState>(
          buildWhen: (previous, current) =>
              previous.hasUnread(ids) != current.hasUnread(ids),
          builder: (context, state) =>
              builder(context, hasUnread: state.hasUnread(ids)),
        );
      },
    );
  }
}
