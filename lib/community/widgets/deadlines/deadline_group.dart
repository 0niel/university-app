import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/community/view/deadlines/deadline_labels.dart';
import 'package:schedule_repository/schedule_repository.dart';

class DeadlineGroup extends StatelessWidget {
  const DeadlineGroup({
    required this.title,
    required this.deadlines,
    required this.pendingDeadlineIds,
    required this.onToggle,
    super.key,
    this.dimmed = false,
    this.now,
  });

  final String title;
  final List<Deadline> deadlines;
  final Set<String> pendingDeadlineIds;
  final ValueChanged<String> onToggle;
  final bool dimmed;
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: AppOverline(title, topPadding: 24, bottomPadding: 12),
        ),
        SliverToBoxAdapter(
          child: Opacity(
            opacity: dimmed ? 0.75 : 1,
            child: AppListGroup(
              children: [
                for (final deadline in deadlines)
                  AppDeadlineRow(
                    key: ValueKey('deadline-${deadline.id}'),
                    title: deadline.title,
                    meta: deadlineMetaLabel(context, deadline, now: now),
                    left: deadlineLeftLabel(context, deadline, now: now),
                    urgent: deadline.isUrgentAt(now ?? DateTime.now()),
                    done: deadline.isDone,
                    onToggle:
                        deadline.isMine &&
                            !pendingDeadlineIds.contains(deadline.id)
                        ? () => onToggle(deadline.id)
                        : null,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
