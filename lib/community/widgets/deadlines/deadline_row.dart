import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/community/view/deadlines/deadline_labels.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:schedule_repository/schedule_repository.dart';

class DeadlineRow extends StatelessWidget {
  const DeadlineRow({
    required this.deadline,
    required this.pending,
    required this.onToggle,
    required this.onDelete,
    required this.onLongPress,
    super.key,
    this.now,
  });

  final Deadline deadline;
  final bool pending;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;
  final VoidCallback onLongPress;
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final current = now ?? DateTime.now();
    final tier = deadlineUrgencyTierAt(deadline, current);
    final row = AppDeadlineRow(
      title: deadline.title,
      meta: deadlineMetaLabel(context, deadline, now: current),
      left: deadlineLeftLabel(context, deadline, now: current),
      urgent: tier == DeadlineUrgencyTier.danger,
      warn: tier == DeadlineUrgencyTier.warn,
      done: deadline.isDone,
      onToggle: pending ? null : onToggle,
    );

    final canSwipe = deadline.isMine && !pending;
    final swipeable = !canSwipe
        ? row
        : Dismissible(
            key: ValueKey('deadline-swipe-${deadline.id}'),
            background: _SwipeBackground(
              leading: true,
              color: context.colors.accent,
              icon: AppLineIcon.check,
              label: deadline.isDone
                  ? l10n.deadlineMarkActive
                  : l10n.deadlineMarkDone,
            ),
            secondaryBackground: _SwipeBackground(
              leading: false,
              color: context.colors.danger,
              icon: AppLineIcon.trash,
              label: l10n.delete,
            ),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                onToggle?.call();
                return false;
              }
              if (onDelete == null) return false;
              onDelete!.call();
              return true;
            },
            child: row,
          );

    return AppPressable(
      onLongPress: onLongPress,
      semanticsLabel: deadline.title,
      child: swipeable,
    );
  }
}

class _SwipeBackground extends StatelessWidget {
  const _SwipeBackground({
    required this.leading,
    required this.color,
    required this.icon,
    required this.label,
  });

  final bool leading;
  final Color color;
  final AppLineIcon icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final content = [
      AppLineIconWidget(icon, color: context.colors.onAccent),
      const SizedBox(width: AppSpacing.sm),
      Flexible(
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.captionStrong.copyWith(
            color: context.colors.onAccent,
          ),
        ),
      ),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        mainAxisAlignment: leading
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: leading ? content : content.reversed.toList(),
      ),
    );
  }
}
