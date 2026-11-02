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
  final changes = context.read<ScheduleChangesCubit>();
  unawaited(cubit.refresh());
  await showAppSheet<void>(
    context,
    showClose: false,
    scrollable: false,
    contentPadding: EdgeInsets.zero,
    child: BlocProvider.value(
      value: cubit,
      child: BlocBuilder<ScheduleChangesCubit, ScheduleChangesState>(
        bloc: changes,
        builder: (context, state) => NotificationsSheet(changes: state.changes),
      ),
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
        );
        final unread = [
          for (final item in feed)
            if (!state.isRead(item.id)) item.id,
        ];
        Widget row(int index) {
          final item = feed[index];
          return NotificationRow(
            key: ValueKey(item.id),
            notification: item,
            isUnread: !state.isRead(item.id),
            timeLabel: notificationAgeLabel(l10n, item.createdAt, now: now),
            onTap: () => unawaited(_open(context, item)),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) => ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: constraints.hasBoundedHeight
                  ? constraints.maxHeight
                  : MediaQuery.heightOf(context) * .75,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screen,
              ),
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
                  if (feed.isEmpty)
                    Flexible(
                      child: SingleChildScrollView(
                        primary: true,
                        child: state.isLoading
                            ? const Padding(
                                padding: EdgeInsets.all(AppSpacing.xlg),
                                child: Center(child: AppSpinner()),
                              )
                            : state.loadFailed
                            ? AppEmptyState(
                                title: l10n.loadingError,
                                actionLabel: l10n.retry,
                                onAction: () => unawaited(
                                  context.read<NotificationsCubit>().refresh(),
                                ),
                              )
                            : AppEmptyState.compact(
                                title: l10n.notificationsEmptyTitle,
                                subtitle: l10n.notificationsEmptySubtitle,
                              ),
                      ),
                    )
                  else
                    Flexible(
                      child: feed.length <= 6
                          ? SingleChildScrollView(
                              primary: true,
                              child: AppListGroup(
                                children: [
                                  for (var i = 0; i < feed.length; i++) row(i),
                                ],
                              ),
                            )
                          : ListView.builder(
                              primary: true,
                              padding: EdgeInsets.zero,
                              itemCount: feed.length,
                              itemBuilder: (context, index) =>
                                  _NotificationGroupRow(
                                    first: index == 0,
                                    last: index == feed.length - 1,
                                    child: row(index),
                                  ),
                            ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _open(BuildContext context, AppNotification item) async {
    context.read<NotificationsCubit>().markRead(item.id);
    final navigator = Navigator.of(context);
    final route = item.route;
    if (route != null) {
      final router = GoRouter.maybeOf(context);
      await navigator.maybePop();
      router?.go(route);
    } else {
      await navigator.maybePop();
    }
  }
}

class _NotificationGroupRow extends StatelessWidget {
  const _NotificationGroupRow({
    required this.first,
    required this.last,
    required this.child,
  });

  final bool first;
  final bool last;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = BorderRadius.vertical(
      top: first ? const Radius.circular(AppRadius.card) : Radius.zero,
      bottom: last ? const Radius.circular(AppRadius.card) : Radius.zero,
    );
    final side = AppSurfaceStyle.outline(context).left;
    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        borderRadius: radius,
        border: Border(
          left: side,
          right: side,
          top: first ? side : BorderSide.none,
          bottom: last ? side : BorderSide.none,
        ),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: ColoredBox(
          color: colors.surface,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              child,
              if (!last)
                AppDivider(
                  color: colors.line.withValues(
                    alpha: colors.line.a * (colors.isDark ? .62 : .75),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
