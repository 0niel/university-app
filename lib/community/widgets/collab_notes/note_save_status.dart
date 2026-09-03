import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/note_editor/note_editor.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class NoteSaveStatus extends StatelessWidget {
  const NoteSaveStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NoteEditorCubit>().state;
    final label = switch (state.status) {
      .dirty => context.l10n.collabNotesUnsaved,
      .saving => context.l10n.collabNotesSaving,
      .failure => context.l10n.collabNotesSaveError,
      .offline => context.l10n.collabNotesOfflineStatus,
      .conflict => context.l10n.collabNotesConflict,
      .readOnly => context.l10n.collabNotesReadOnlyBanner,
      .saved => context.l10n.collabNotesSaved,
      .clean || .deleted => context.l10n.collabNotesUpdatedAutosave(
        _relativeTime(context, state.savedAt),
      ),
    };
    final colors = context.colors;
    final color = switch (state.status) {
      .failure || .readOnly => colors.exam,
      .offline => colors.warn,
      _ => colors.muted,
    };
    final pulsing = state.status == .dirty || state.status == .saving;
    return Semantics(
      liveRegion: true,
      label: label,
      child: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.xsm),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (pulsing) ...[
              AppPulseDot(size: 6, color: colors.accent),
              const SizedBox(width: 5),
            ],
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: AppText.captionSmall.copyWith(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _relativeTime(BuildContext context, DateTime? date) {
    if (date == null) return '';
    final difference = DateTime.now().difference(date.toLocal());
    if (difference.inMinutes < 1) return context.l10n.lostFoundJustNow;
    if (difference.inMinutes < 60) {
      return context.l10n.groupSpaceTimeMinutes(difference.inMinutes);
    }
    if (difference.inHours < 24) {
      return context.l10n.groupSpaceTimeHours(difference.inHours);
    }
    return context.l10n.groupSpaceTimeDays(difference.inDays);
  }
}
