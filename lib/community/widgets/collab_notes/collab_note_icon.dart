import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/community/models/note_kind.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CollabNoteIcon extends StatelessWidget {
  const CollabNoteIcon({super.key, this.kind = NoteKind.doc});

  final NoteKind kind;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tone = switch (kind) {
      NoteKind.lecture => colors.lecture,
      NoteKind.practice => colors.practice,
      NoteKind.lab => colors.lab,
      NoteKind.doc => colors.accent,
    };
    final label = switch (kind) {
      NoteKind.lecture => context.l10n.collabNotesKindLecture,
      NoteKind.practice => context.l10n.collabNotesKindPractice,
      NoteKind.lab => context.l10n.lessonShortLab,
      NoteKind.doc => '',
    };
    return Container(
      width: 44,
      height: 44,
      alignment: .center,
      decoration: BoxDecoration(
        color: colors.tintOf(tone),
        borderRadius: .circular(AppRadius.tile),
      ),
      child: label.isEmpty
          ? AppLineIconWidget(.pencil, size: 18, color: tone)
          : Text(label, style: AppText.typeTag.copyWith(color: tone)),
    );
  }
}
