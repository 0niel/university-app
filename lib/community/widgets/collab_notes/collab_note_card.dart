import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/collab_note_card_title.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/collab_note_icon.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CollabNoteCard extends StatelessWidget {
  const CollabNoteCard({required this.note, required this.onTap, super.key});

  final CollabNote note;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final excerpt = note.content.trim().replaceAll('\n', ' ');
    final editor = note.updatedByName.isEmpty ? '' : ' · ${note.updatedByName}';
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        NinjaMetrics.screenPadding,
        0,
        NinjaMetrics.screenPadding,
        10,
      ),
      child: AppPressable(
        onTap: onTap,
        semanticsLabel: note.title,
        semanticsButton: onTap != null,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(NinjaRadius.card),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CollabNoteIcon(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      CollabNoteCardTitle(note: note),
                      const SizedBox(height: 2),
                      Text(
                        context.l10n.collabNotesUpdated(
                              _relativeTime(context, note.updatedAt),
                            ) +
                            editor,
                        maxLines: 1,
                        overflow: .ellipsis,
                        style: NinjaText.helper.copyWith(
                          color: colors.muted,
                        ),
                      ),
                      if (excerpt.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          excerpt,
                          maxLines: 2,
                          overflow: .ellipsis,
                          style: NinjaText.subtext.copyWith(
                            color: colors.mutedDark,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                AppLineIconWidget(.chevronR, size: 16, color: colors.chevron),
              ],
            ),
          ),
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
