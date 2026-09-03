import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/community/cubit/deadlines/deadlines.dart';
import 'package:rtu_mirea_app/home/view/home_labels.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:schedule_repository/schedule_repository.dart';

class HomeDeadlinesGroup extends StatelessWidget {
  const HomeDeadlinesGroup({
    required this.state,
    required this.now,
    required this.onAdd,
    required this.onOpen,
    required this.onToggle,
    required this.onRetry,
    super.key,
  });
  final DeadlinesState state;
  final DateTime now;
  final VoidCallback onAdd;
  final VoidCallback onOpen;
  final ValueChanged<Deadline> onToggle;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final deadlines = [...state.deadlines]
      ..sort((a, b) {
        if (a.isDone != b.isDone) return a.isDone ? 1 : -1;
        return a.dueAt.compareTo(b.dueAt);
      });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionTitle(
          title: l10n.homeDeadlines,
          action: l10n.homeAddDeadline,
          onActionTap: onAdd,
          bottomPadding: 14,
        ),
        if (state.status == DeadlinesStatus.failure)
          AppBanner(
            message: l10n.loadingError,
            tone: AppBannerTone.warn,
            actionLabel: l10n.retry,
            onAction: onRetry,
          ),
        if ((state.status == DeadlinesStatus.initial ||
                state.status == DeadlinesStatus.loading) &&
            deadlines.isEmpty)
          const AppListGroup(
            children: [AppSkeletonRow(), AppSkeletonRow(), AppSkeletonRow()],
          )
        else if (deadlines.isEmpty && state.status != DeadlinesStatus.failure)
          AppEmptyState.compact(title: l10n.homeDeadlinesAllDone)
        else if (deadlines.isNotEmpty)
          AppListGroup(
            children: [
              for (final deadline in deadlines.take(3))
                AppDeadlineRow(
                  title: deadline.title,
                  meta: homeDeadlineMeta(l10n, deadline, now),
                  left: homeDeadlineLeft(l10n, deadline, now),
                  urgent: deadline.isUrgentAt(now),
                  done: deadline.isDone,
                  onTap: onOpen,
                  onToggle:
                      deadline.isMine &&
                          !state.pendingDeadlineIds.contains(deadline.id)
                      ? () => onToggle(deadline)
                      : null,
                ),
            ],
          ),
      ],
    );
  }
}
