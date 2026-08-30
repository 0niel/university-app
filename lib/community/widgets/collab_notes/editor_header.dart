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
        NinjaMetrics.screenPadding,
        8,
        NinjaMetrics.screenPadding,
        8,
      ),
      child: Row(
        children: [
          NinjaIconButton(
            icon: const AppLineIconWidget(AppLineIcon.chevronL, size: 20),
            tooltip: context.l10n.back,
            onPressed: onBack,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.collabNotesEditorHeader(state.title),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: NinjaText.headline.copyWith(color: context.ninja.ink),
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
                          color: context.ninja.brand,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          presenceLabel,
                          overflow: TextOverflow.ellipsis,
                          style: NinjaText.helper.copyWith(
                            color: context.ninja.brandInk,
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
              style: NinjaText.helper.copyWith(
                color: context.ninja.muted,
              ),
            ),
        ],
      ),
    );
  }
}
