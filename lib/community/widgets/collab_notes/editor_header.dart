import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/note_editor/note_editor.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/note_save_status.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class EditorHeader extends StatefulWidget {
  const EditorHeader({
    required this.onBack,
    required this.onShare,
    required this.onMore,
    super.key,
  });

  final VoidCallback onBack;
  final VoidCallback onShare;
  final VoidCallback onMore;

  @override
  State<EditorHeader> createState() => _EditorHeaderState();
}

class _EditorHeaderState extends State<EditorHeader> {
  late final _titleController = TextEditingController(
    text: context.read<NoteEditorCubit>().state.title,
  );
  final _titleFocus = FocusNode();

  @override
  void dispose() {
    _titleController.dispose();
    _titleFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final state = context.watch<NoteEditorCubit>().state;
    if (_titleController.text != state.title && !_titleFocus.hasFocus) {
      _titleController.text = state.title;
    }
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
          AppIconButton(
            icon: const AppLineIconWidget(AppLineIcon.chevronL, size: 20),
            tooltip: context.l10n.back,
            onPressed: widget.onBack,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _titleController,
                      builder: (context, value, _) => value.text.isEmpty
                          ? Text(
                              context.l10n.collabNotesTitleHint,
                              style: AppText.headline.copyWith(
                                color: colors.muted,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    EditableText(
                      key: const ValueKey('collab-note-title-field'),
                      controller: _titleController,
                      focusNode: _titleFocus,
                      readOnly: !state.canRename,
                      onChanged: context.read<NoteEditorCubit>().titleChanged,
                      style: AppText.headline.copyWith(
                        color: state.readOnly ? colors.muted2 : colors.ink,
                      ),
                      cursorColor: colors.ink,
                      backgroundCursorColor: colors.canvas,
                      selectionColor: colors.tint,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _titleFocus.unfocus(),
                    ),
                  ],
                ),
                if (editors.length > 1)
                  Semantics(
                    liveRegion: true,
                    label: presenceLabel,
                    child: Row(
                      children: [
                        AppDot(size: 6, color: colors.accent),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            presenceLabel,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.captionSmall.copyWith(
                              color: colors.accent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  const NoteSaveStatus(),
              ],
            ),
          ),
          if (editors.isNotEmpty) ...[
            const SizedBox(width: AppSpacing.sm),
            Semantics(
              label: context.l10n.collabNotesCollaboratorsTooltip,
              child: AppAvatarStack(names: editors.take(3).toList(), size: 28),
            ),
          ],
          const SizedBox(width: AppSpacing.xs),
          AppIconButton(
            icon: const AppLineIconWidget(AppLineIcon.share, size: 18),
            tooltip: context.l10n.share,
            size: .small,
            onPressed: widget.onShare,
          ),
          const SizedBox(width: AppSpacing.xs),
          AppIconButton(
            icon: const AppLineIconWidget(AppLineIcon.more, size: 18),
            tooltip: context.l10n.more,
            size: .small,
            onPressed: widget.onMore,
          ),
        ],
      ),
    );
  }
}
