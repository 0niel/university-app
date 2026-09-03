import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/collab_notes/collab_notes.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

Future<void> showNoteActionsSheet(BuildContext context, CollabNote note) async {
  final cubit = context.read<CollabNotesCubit>();
  final action = await showAppSheet<String>(
    context,
    title: note.title,
    child: AppListGroup(
      children: [
        if (note.isMine) ...[
          AppListRow(
            leading: const AppIconTile(icon: AppLineIcon.pencil),
            title: context.l10n.collabNotesActionRename,
            isFirst: true,
            onTap: () => Navigator.of(context).pop('rename'),
          ),
          AppListRow(
            leading: const AppIconTile(icon: AppLineIcon.people),
            title: context.l10n.collabNotesActionVisibility,
            onTap: () => Navigator.of(context).pop('visibility'),
          ),
          AppListRow(
            leading: const AppIconTile(icon: AppLineIcon.trash),
            title: context.l10n.collabNotesDelete,
            destructive: true,
            onTap: () => Navigator.of(context).pop('delete'),
          ),
        ],
      ],
    ),
  );
  if (!context.mounted || action == null) return;
  switch (action) {
    case 'rename':
      unawaited(_rename(context, cubit, note));
    case 'visibility':
      unawaited(_changeVisibility(context, cubit, note));
    case 'delete':
      unawaited(_delete(context, cubit, note));
  }
}

Future<void> _rename(
  BuildContext context,
  CollabNotesCubit cubit,
  CollabNote note,
) async {
  final controller = TextEditingController(text: note.title);
  final title = await showAppSheet<String>(
    context,
    title: context.l10n.collabNotesRenameTitle,
    child: _RenameSheet(controller: controller),
  );
  controller.dispose();
  if (title == null || title.trim().isEmpty) return;
  final ok = await cubit.rename(note.id, title.trim());
  if (context.mounted && !ok) {
    showNinjaToast(
      context,
      showCheck: false,
      message: context.l10n.collabNotesRenameError,
    );
  }
}

Future<void> _changeVisibility(
  BuildContext context,
  CollabNotesCubit cubit,
  CollabNote note,
) async {
  final target = note.isPersonal
      ? CollabNoteVisibility.group
      : CollabNoteVisibility.personal;
  final ok = await cubit.setVisibility(note.id, target);
  if (context.mounted && !ok) {
    showNinjaToast(
      context,
      showCheck: false,
      message: context.l10n.collabNotesVisibilityError,
    );
  }
}

Future<void> _delete(
  BuildContext context,
  CollabNotesCubit cubit,
  CollabNote note,
) async {
  final confirmed = await showAppConfirmDialog(
    context,
    title: context.l10n.collabNotesDeleteTitle,
    message: context.l10n.collabNotesDeleteBody,
    confirmLabel: context.l10n.collabNotesDelete,
    cancelLabel: context.l10n.collabNotesCancel,
    destructive: true,
  );
  if (!confirmed || !context.mounted) return;
  final ok = await cubit.delete(note.id);
  if (context.mounted && !ok) {
    showNinjaToast(
      context,
      showCheck: false,
      message: context.l10n.collabNotesDeleteError,
    );
  }
}

class _RenameSheet extends StatelessWidget {
  const _RenameSheet({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppInputField(
          controller: controller,
          placeholder: context.l10n.collabNotesRenameHint,
          maxLength: 200,
          autofocus: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (value) => Navigator.of(context).pop(value),
        ),
        const SizedBox(height: AppSpacing.fieldGap),
        AppButton.primary(
          label: context.l10n.save,
          expanded: true,
          size: AppButtonSize.large,
          onPressed: () => Navigator.of(context).pop(controller.text),
        ),
      ],
    );
  }
}
