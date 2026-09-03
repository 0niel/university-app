import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CollabNoteCardTitle extends StatelessWidget {
  const CollabNoteCardTitle({required this.note, super.key});

  final CollabNote note;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      crossAxisAlignment: .center,
      children: [
        Text(
          note.title,
          maxLines: 2,
          overflow: .ellipsis,
          style: AppText.sans(
            14.5,
            FontWeight.w600,
          ).copyWith(color: context.colors.ink),
        ),
        if (note.isPersonal)
          NinjaBadge(context.l10n.collabNotesPersonalBadge, tone: .ink),
      ],
    );
  }
}
