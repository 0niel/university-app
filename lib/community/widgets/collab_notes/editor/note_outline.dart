import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/note_document_navigation.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class NoteOutline extends StatelessWidget {
  const NoteOutline({
    required this.controller,
    required this.onSelected,
    super.key,
  });
  final QuillController controller;
  final ValueChanged<NoteHeading> onSelected;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) {
      final headings = noteHeadings(controller.document);
      if (headings.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.screen),
          child: Text(
            context.l10n.noteOutlineEmpty,
            style: AppText.subtext.copyWith(color: context.colors.muted),
          ),
        );
      }
      return ListView.builder(
        key: const ValueKey('note-outline-list'),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        itemCount: headings.length,
        itemBuilder: (context, index) {
          final heading = headings[index];
          return Padding(
            padding: EdgeInsets.only(
              left: (heading.level - 1).clamp(0, 3) * 12.0,
            ),
            child: AppListRow(
              title: heading.title,
              onTap: () => onSelected(heading),
            ),
          );
        },
      );
    },
  );
}
