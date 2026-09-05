import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/notifications/cubit/notifications_cubit.dart';
import 'package:rtu_mirea_app/notifications/model/app_notification.dart';
import 'package:rtu_mirea_app/notifications/model/notification_feed.dart';
import 'package:rtu_mirea_app/notifications/view/widgets/notification_row.dart';
import 'package:rtu_mirea_app/notifications/view/widgets/notifications_sheet_header.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:schedule_repository/schedule_repository.dart';

Future<void> showNotificationsSheet(BuildContext context) async {
  final cubit = context.read<NotificationsCubit>();
  final changes = context.read<ScheduleChangesCubit>().state.changes;
  unawaited(cubit.refresh());
  await showAppSheet<void>(
    context,
    showClose: false,
    contentPadding: EdgeInsets.zero,
    child: BlocProvider.value(
      value: cubit,
      child: NotificationsSheet(changes: changes),
    ),
  );
}

class NotificationsSheet extends StatelessWidget {
  const NotificationsSheet({
    required this.changes,
    this.now,
    super.key,
  });

  final List<ScheduleChange> changes;
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        final feed = buildNotificationFeed(
          l10n: l10n,
          pushes: state.pushes,
          changes: changes,
          now: now,
        );
        final unread = [
          for (final item in feed)
            if (!state.isRead(item.id)) item.id,
        ];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NotificationsSheetHeader(
                onReadAll: unread.isEmpty
                    ? null
                    : () => context.read<NotificationsCubit>().markAllRead(
                        unread,
                      ),
              ),
              if (feed.isEmpty && state.isLoading)
                const Padding(
                  padding: EdgeInsets.all(AppSpacing.xlg),
                  child: Center(child: AppSpinner()),
                )
              else if (feed.isEmpty && state.loadFailed)
                AppEmptyState(
                  title: l10n.loadingError,
                  actionLabel: l10n.retry,
                  onAction: () => unawaited(
                    context.read<NotificationsCubit>().refresh(),
                  ),
                )
              else if (feed.isEmpty)
                AppEmptyState.compact(
                  title: l10n.notificationsEmptyTitle,
                  subtitle: l10n.notificationsEmptySubtitle,
                )
              else
                AppListGroup(
                  children: [
                    for (final item in feed)
                      NotificationRow(
                        notification: item,
                        isUnread: !state.isRead(item.id),
                        timeLabel: notificationAgeLabel(
                          l10n,
                          item.createdAt,
                          now: now,
                        ),
                        onTap: () => unawaited(_open(context, item)),
                      ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _open(BuildContext context, AppNotification item) async {
    context.read<NotificationsCubit>().markRead(item.id);
    final route = item.route;
    final router = GoRouter.maybeOf(context);
    await Navigator.of(context).maybePop();
    if (route != null) router?.go(route);
  }
}
