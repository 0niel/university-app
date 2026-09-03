import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/community/models/note_kind.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/collab_note_card_title.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/collab_note_icon.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CollabNoteCard extends StatelessWidget {
  const CollabNoteCard({
    required this.note,
    required this.onTap,
    super.key,
    this.onLongPress,
  });

  final CollabNote note;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final excerpt = note.content.trim().replaceAll('\n', ' ');
    final editor = note.updatedByName.isEmpty ? '' : ' · ${note.updatedByName}';
    return AppPressable(
      onTap: onTap,
      onLongPress: onLongPress,
      semanticsLabel: note.title,
      semanticsButton: onTap != null,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              CollabNoteIcon(kind: NoteKind.fromTitle(note.title)),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    CollabNoteCardTitle(note: note),
                    const SizedBox(height: 3),
                    Text(
                      context.l10n.collabNotesUpdated(
                            _relativeTime(context, note.updatedAt),
                          ) +
                          editor,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: AppText.sans(12, FontWeight.w400).copyWith(
                        color: colors.muted,
                      ),
                    ),
                    if (excerpt.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(
                        excerpt,
                        maxLines: 2,
                        overflow: .ellipsis,
                        style: AppText.subtext.copyWith(
                          color: colors.muted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              if (note.collaboratorNames.length > 1) ...[
                Semantics(
                  label: context.l10n.collabNotesCollaboratorsTooltip,
                  child: AppAvatarStack(
                    names: note.collaboratorNames.take(3).toList(),
                    size: 22,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              AppLineIconWidget(.chevronR, size: 16, color: colors.muted2),
            ],
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
