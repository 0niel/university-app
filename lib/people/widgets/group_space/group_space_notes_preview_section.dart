import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/collab_note_card.dart';

class GroupSpaceNotesPreviewSection extends StatelessWidget {
  const GroupSpaceNotesPreviewSection({
    required this.notes,
    required this.onOpen,
    super.key,
    this.maxItems = 3,
  });

  final List<CollabNote> notes;
  final ValueChanged<CollabNote> onOpen;
  final int maxItems;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final visible = notes.take(maxItems).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: Column(
            children: [
              for (final (index, note) in visible.indexed) ...[
                if (index > 0) const AppDivider(indent: 66),
                CollabNoteCard(note: note, onTap: () => onOpen(note)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
