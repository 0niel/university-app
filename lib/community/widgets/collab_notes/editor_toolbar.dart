import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/note_editor/note_editor.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor_toolbar_action.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class EditorToolbar extends StatelessWidget {
  const EditorToolbar({
    required this.onSave,
    required this.onFocus,
    required this.onDelete,
    required this.onShare,
    super.key,
  });

  final VoidCallback onSave;
  final VoidCallback onFocus;
  final VoidCallback onDelete;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NoteEditorCubit>().state;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.xsm,
        AppSpacing.screen,
        AppSpacing.gap,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            spacing: 8,
            children: [
              EditorToolbarAction(
                icon: .pencil,
                tooltip: context.l10n.collabNotesToolbarEdit,
                onPressed: onFocus,
              ),
              EditorToolbarAction(
                icon: .check,
                tooltip: context.l10n.collabNotesToolbarSave,
                onPressed: state.status == .saving || state.isDeleting
                    ? null
                    : onSave,
              ),
              if (state.canDelete)
                EditorToolbarAction(
                  icon: .trash,
                  destructive: true,
                  tooltip: context.l10n.collabNotesDelete,
                  onPressed: state.isDeleting ? null : onDelete,
                ),
              const Spacer(),
              EditorToolbarAction(
                icon: .share,
                tooltip: context.l10n.share,
                onPressed: state.isDeleting ? null : onShare,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
