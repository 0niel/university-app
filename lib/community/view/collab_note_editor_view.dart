import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/note_editor/note_editor.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor_header.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor_toolbar.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/note_save_status.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:share_plus/share_plus.dart';

class CollabNoteEditorView extends StatefulWidget {
  const CollabNoteEditorView({super.key});

  @override
  State<CollabNoteEditorView> createState() => _CollabNoteEditorViewState();
}

class _CollabNoteEditorViewState extends State<CollabNoteEditorView> {
  late final _titleController = TextEditingController(
    text: context.read<NoteEditorCubit>().state.title,
  );
  late final _contentController = TextEditingController(
    text: context.read<NoteEditorCubit>().state.content,
  );
  final _contentFocus = FocusNode();
  var _exiting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _contentFocus.dispose();
    super.dispose();
  }

  Future<void> _exit() async {
    if (_exiting) return;
    _exiting = true;
    final saved = await context.read<NoteEditorCubit>().flush();
    if (!mounted) return;
    _exiting = false;
    if (saved) {
      Navigator.of(context).pop();
      return;
    }
    final discard = await _confirmDiscard();
    if (discard && mounted) {
      context.read<NoteEditorCubit>().discardChanges();
      Navigator.of(context).pop();
    }
  }

  Future<bool> _confirmDiscard() {
    return showNinjaConfirmDialog(
      context,
      title: context.l10n.collabNotesDiscardTitle,
      message: context.l10n.collabNotesDiscardBody,
      confirmLabel: context.l10n.collabNotesDiscard,
      cancelLabel: context.l10n.collabNotesStay,
      destructive: true,
    );
  }

  Future<void> _delete() async {
    final confirmed = await showNinjaConfirmDialog(
      context,
      title: context.l10n.collabNotesDeleteTitle,
      message: context.l10n.collabNotesDeleteBody,
      confirmLabel: context.l10n.collabNotesDelete,
      cancelLabel: context.l10n.collabNotesCancel,
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    final deleted = await context.read<NoteEditorCubit>().delete();
    if (!mounted) return;
    if (deleted) {
      Navigator.of(context).pop();
    } else {
      _showError(context.l10n.collabNotesDeleteError);
    }
  }

  void _share() {
    final state = context.read<NoteEditorCubit>().state;
    final text = '${state.title.trim()}\n\n${state.content.trim()}'.trim();
    if (text.isNotEmpty) {
      unawaited(SharePlus.instance.share(ShareParams(text: text)));
    }
  }

  Future<void> _manualSave() async {
    final saved = await context.read<NoteEditorCubit>().flush();
    if (!saved && mounted) {
      _showError(context.l10n.collabNotesSaveError);
    }
  }

  void _showError(String message) {
    showNinjaToast(context, showCheck: false, message: message);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return PopScope<void>(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) unawaited(_exit());
      },
      child: Column(
        children: [
          EditorHeader(onBack: () => unawaited(_exit())),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              children: [
                TextField(
                  controller: _titleController,
                  maxLength: 200,
                  maxLines: null,
                  onChanged: context.read<NoteEditorCubit>().titleChanged,
                  cursorColor: colors.ink,
                  style: NinjaText.display.copyWith(
                    color: colors.ink,
                    fontWeight: .w700,
                  ),
                  decoration: _decoration(
                    context.l10n.collabNotesTitleHint,
                    NinjaText.display.copyWith(
                      color: colors.muted,
                      fontWeight: .w700,
                    ),
                  ),
                ),
                const NoteSaveStatus(),
                const SizedBox(height: 18),
                TextField(
                  controller: _contentController,
                  focusNode: _contentFocus,
                  minLines: 10,
                  maxLines: null,
                  maxLength: 20000,
                  onChanged: context.read<NoteEditorCubit>().contentChanged,
                  keyboardType: .multiline,
                  cursorColor: colors.ink,
                  style: NinjaText.body.copyWith(
                    color: colors.ink,
                    height: 1.5,
                  ),
                  decoration: _decoration(
                    context.l10n.collabNotesBodyHint,
                    NinjaText.body.copyWith(
                      color: colors.muted,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          EditorToolbar(
            onSave: () => unawaited(_manualSave()),
            onFocus: _contentFocus.requestFocus,
            onDelete: () => unawaited(_delete()),
            onShare: _share,
          ),
        ],
      ),
    );
  }

  InputDecoration _decoration(String hint, TextStyle hintStyle) {
    return InputDecoration(
      isCollapsed: true,
      isDense: true,
      filled: false,
      contentPadding: EdgeInsets.zero,
      border: .none,
      enabledBorder: .none,
      focusedBorder: .none,
      counterText: '',
      hintText: hint,
      hintStyle: hintStyle,
    );
  }
}
