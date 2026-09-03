import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/note_editor/note_editor.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class EditorHeader extends StatelessWidget {
  const EditorHeader({required this.onBack, super.key});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NoteEditorCubit>().state;
    final editors = state.editors;
    final presenceLabel = editors.length <= 1
        ? context.l10n.collabNotesPresenceSolo
        : context.l10n.collabNotesPresenceEditing(editors.length);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.sm,
        AppSpacing.screen,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          NinjaIconButton(
            icon: const AppLineIconWidget(AppLineIcon.chevronL, size: 20),
            tooltip: context.l10n.back,
            onPressed: onBack,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.collabNotesEditorHeader(state.title),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.headline.copyWith(color: context.colors.ink),
                ),
                Semantics(
                  liveRegion: true,
                  label: presenceLabel,
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: context.colors.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          presenceLabel,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.captionSmall.copyWith(
                            color: context.colors.accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (editors.isNotEmpty)
            AppAvatarStack(names: editors.take(3).toList(), size: 30),
          if (editors.length > 3)
            Text(
              '+${editors.length - 3}',
              style: AppText.captionSmall.copyWith(
                color: context.colors.muted,
              ),
            ),
        ],
      ),
    );
  }
}
