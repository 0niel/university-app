import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/community/cubit/deadlines/deadlines.dart';
import 'package:rtu_mirea_app/community/view/deadlines/deadline_actions_sheet.dart';
import 'package:rtu_mirea_app/community/widgets/deadlines/deadline_row.dart';
import 'package:schedule_repository/schedule_repository.dart';

class DeadlineGroup extends StatelessWidget {
  const DeadlineGroup({
    required this.title,
    required this.deadlines,
    required this.pendingDeadlineIds,
    required this.onToggle,
    super.key,
    this.onDelete,
    this.cubit,
    this.now,
    this.dimmed = false,
    this.collapsible = false,
    this.expanded = true,
    this.onToggleExpanded,
  });

  final String title;
  final List<Deadline> deadlines;
  final Set<String> pendingDeadlineIds;
  final ValueChanged<String> onToggle;
  final ValueChanged<String>? onDelete;
  final DeadlinesCubit? cubit;
  final DateTime? now;
  final bool dimmed;
  final bool collapsible;
  final bool expanded;
  final VoidCallback? onToggleExpanded;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final header = collapsible
        ? AppPressable(
            onTap: onToggleExpanded,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 24,
                bottom: 12,
                left: AppSpacing.xxs,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${title.toUpperCase()} · ${deadlines.length}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.overline.copyWith(color: colors.muted),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AppLineIconWidget(
                    expanded ? AppLineIcon.chevronU : AppLineIcon.chevronD,
                    size: AppIconSize.sm,
                    color: colors.muted,
                  ),
                ],
              ),
            ),
          )
        : AppOverline(
            '$title · ${deadlines.length}',
            topPadding: 24,
            bottomPadding: 12,
          );

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(child: header),
        if (!collapsible || expanded)
          SliverToBoxAdapter(
            child: Opacity(
              opacity: dimmed ? 0.75 : 1,
              child: AppListGroup(
                children: [
                  for (final deadline in deadlines)
                    DeadlineRow(
                      key: ValueKey('deadline-${deadline.id}'),
                      deadline: deadline,
                      now: now,
                      pending: pendingDeadlineIds.contains(deadline.id),
                      onToggle: deadline.isMine
                          ? () => onToggle(deadline.id)
                          : null,
                      onDelete: onDelete == null
                          ? null
                          : () => onDelete!(deadline.id),
                      onLongPress: cubit == null
                          ? () {}
                          : () => showDeadlineActionsSheet(
                              context,
                              cubit: cubit!,
                              deadline: deadline,
                            ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
