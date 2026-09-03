import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/community/cubit/deadlines/deadlines.dart';
import 'package:rtu_mirea_app/community/models/models.dart';
import 'package:rtu_mirea_app/community/view/deadlines/add_deadline_sheet.dart';
import 'package:rtu_mirea_app/community/view/deadlines/deadline_labels.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:share_plus/share_plus.dart';

Future<void> showDeadlineActionsSheet(
  BuildContext context, {
  required DeadlinesCubit cubit,
  required Deadline deadline,
}) {
  final l10n = context.l10n;
  final navigator = Navigator.of(context, rootNavigator: true);
  void run(VoidCallback action) {
    navigator.pop();
    if (context.mounted) action();
  }

  return showAppSheet<void>(
    context,
    title: deadline.title,
    child: AppListGroup(
      children: [
        if (deadline.isMine)
          AppListRow(
            title: l10n.edit,
            leading: const AppLineIconWidget(AppLineIcon.pencil),
            strong: true,
            showChevron: false,
            onTap: () => run(
              () => showAddDeadlineSheet(
                context,
                cubit: cubit,
                editing: deadline,
              ),
            ),
          ),
        AppListRow(
          title: l10n.deadlineActionDuplicate,
          leading: const AppLineIconWidget(AppLineIcon.clipboard),
          strong: true,
          showChevron: false,
          onTap: () => run(() async {
            final created = await cubit.createDeadline(
              DeadlineDraft(
                title: deadline.title,
                dueAt: deadline.dueAt,
                source: deadline.source,
                subjectName: deadline.subjectName,
                priority: deadline.priority,
                remind: deadline.remind,
                remindMinutes: deadline.remindMinutes,
              ),
            );
            if (!context.mounted) return;
            if (created) {
              ToastManager.showSuccess(
                context,
                message: l10n.deadlineDuplicatedToast,
              );
            } else {
              ToastManager.showError(
                context,
                message: l10n.deadlinesCreateError,
              );
            }
          }),
        ),
        AppListRow(
          title: l10n.share,
          leading: const AppLineIconWidget(AppLineIcon.share),
          strong: true,
          showChevron: false,
          onTap: () => run(() {
            final when = deadlineDateLabel(context, deadline.dueAt);
            unawaited(
              SharePlus.instance.share(
                ShareParams(
                  text: l10n.deadlineShareMessage(deadline.title, when),
                ),
              ),
            );
          }),
        ),
        if (deadline.isMine)
          AppListRow(
            title: l10n.delete,
            leading: const AppLineIconWidget(AppLineIcon.trash),
            strong: true,
            destructive: true,
            showChevron: false,
            onTap: () => run(() {
              cubit.deleteDeadline(deadline.id);
              ToastManager.showInfo(
                context,
                message: l10n.deadlineDeletedToast,
                actionLabel: l10n.undo,
                onAction: () => cubit.undoDeleteDeadline(deadline.id),
              );
            }),
          ),
      ],
    ),
  );
}
