import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/polls/cubit/polls_cubit.dart';

Future<void> showPollOwnerActionsSheet(
  BuildContext context, {
  required Poll poll,
  required PollsCubit cubit,
}) {
  return showAppSheet<void>(
    context,
    title: context.l10n.pollsOwnerActions,
    child: PollOwnerActionsSheet(poll: poll, cubit: cubit),
  );
}

class PollOwnerActionsSheet extends StatefulWidget {
  const PollOwnerActionsSheet({
    required this.poll,
    required this.cubit,
    super.key,
  });

  final Poll poll;
  final PollsCubit cubit;

  @override
  State<PollOwnerActionsSheet> createState() => _PollOwnerActionsSheetState();
}

class _PollOwnerActionsSheetState extends State<PollOwnerActionsSheet> {
  bool _closing = false;
  bool _deleting = false;

  Future<void> _close() async {
    if (_closing || _deleting || !widget.poll.isMine) return;
    final l10n = context.l10n;
    final confirmed = await showAppConfirmDialog(
      context,
      title: l10n.pollsCloseConfirmTitle,
      message: l10n.pollsCloseConfirmBody,
      confirmLabel: l10n.pollsCloseAction,
      cancelLabel: l10n.pollsDeleteCancel,
    );
    if (!confirmed || !mounted) return;
    setState(() => _closing = true);
    final navigator = Navigator.of(context);
    final ok = await widget.cubit.closePoll(widget.poll);
    if (!mounted) return;
    setState(() => _closing = false);
    if (ok) {
      ToastManager.showSuccess(context, message: l10n.pollsCloseSuccess);
      navigator.pop();
    } else {
      ToastManager.showError(context, message: l10n.pollsCloseError);
    }
  }

  Future<void> _delete() async {
    if (_closing || _deleting || !widget.poll.isMine) return;
    final l10n = context.l10n;
    final confirmed = await showAppConfirmDialog(
      context,
      title: l10n.pollsDeleteConfirmTitle,
      message: l10n.pollsDeleteConfirmBody,
      confirmLabel: l10n.pollsDelete,
      cancelLabel: l10n.pollsDeleteCancel,
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    setState(() => _deleting = true);
    final navigator = Navigator.of(context);
    final ok = await widget.cubit.deletePoll(widget.poll);
    if (!mounted) return;
    setState(() => _deleting = false);
    if (ok) {
      ToastManager.showSuccess(context, message: l10n.pollsDeleteSuccess);
      navigator.pop();
    } else {
      ToastManager.showError(context, message: l10n.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final poll = widget.poll;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!poll.isEnded) ...[
          AppButton.secondary(
            label: l10n.pollsCloseAction,
            expanded: true,
            loading: _closing,
            onPressed: _deleting || _closing ? null : () => unawaited(_close()),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        AppButton.destructive(
          label: l10n.pollsDelete,
          expanded: true,
          loading: _deleting,
          onPressed: _closing || _deleting ? null : () => unawaited(_delete()),
        ),
      ],
    );
  }
}
