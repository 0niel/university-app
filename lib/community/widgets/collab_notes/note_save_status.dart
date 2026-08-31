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
      .conflict => context.l10n.collabNotesConflict,
      .saved => context.l10n.collabNotesSaved,
      .clean || .deleted => context.l10n.collabNotesUpdatedAutosave(
        _relativeTime(context, state.savedAt),
      ),
    };
    final color = state.status == .failure
        ? context.ninja.scarlet
        : context.ninja.muted;
    return Semantics(
      liveRegion: true,
      label: label,
      child: Padding(
        padding: const .only(top: 6),
        child: Text(label, style: NinjaText.helper.copyWith(color: color)),
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
