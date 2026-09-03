import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:rtu_mirea_app/common/media_viewer/media_viewer.dart';
import 'package:rtu_mirea_app/community/cubit/note_editor/note_editor.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/note_editor_styles.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/note_embed_builders.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/note_toolbar.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor_header.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:share_plus/share_plus.dart';

class CollabNoteEditorView extends StatefulWidget {
  const CollabNoteEditorView({super.key});

  @override
  State<CollabNoteEditorView> createState() => _CollabNoteEditorViewState();
}

class _CollabNoteEditorViewState extends State<CollabNoteEditorView>
    with WidgetsBindingObserver {
  final _editorFocus = FocusNode();
  final _editorScroll = ScrollController();
  var _exiting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(context.read<NoteEditorCubit>().resynchronize());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _editorFocus.dispose();
    _editorScroll.dispose();
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
    if (!mounted) return;
    if (discard) {
      context.read<NoteEditorCubit>().discardChanges();
      Navigator.of(context).pop();
    }
  }

  Future<bool> _confirmDiscard() {
    return showAppConfirmDialog(
      context,
      title: context.l10n.collabNotesDiscardTitle,
      message: context.l10n.collabNotesDiscardBody,
      confirmLabel: context.l10n.collabNotesDiscard,
      cancelLabel: context.l10n.collabNotesStay,
      destructive: true,
    );
  }

  Future<void> _delete() async {
    final confirmed = await showAppConfirmDialog(
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
      _showToast(context.l10n.collabNotesDeleteError);
    }
  }

  void _share() {
    final cubit = context.read<NoteEditorCubit>();
    final title = cubit.state.title.trim();
    final body = cubit.controller.document.toPlainText().trim();
    final text = '$title\n\n$body'.trim();
    if (text.isNotEmpty) {
      unawaited(SharePlus.instance.share(ShareParams(text: text)));
    }
  }

  Future<void> _openMore() async {
    final action = await showAppSheet<String>(
      context,
      title: context.l10n.more,
      child: AppListGroup(
        children: [
          AppListRow(
            leading: const AppIconTile(icon: AppLineIcon.trash),
            title: context.l10n.collabNotesDelete,
            destructive: true,
            isFirst: true,
            onTap: () => Navigator.of(context).pop('delete'),
          ),
        ],
      ),
    );
    if (!mounted || action == null) return;
    if (action == 'delete') unawaited(_delete());
  }

  void _showToast(String message) {
    showNinjaToast(context, showCheck: false, message: message);
  }

  void _onImageTap(String url) {
    unawaited(
      showMediaViewer(
        context,
        items: [MediaItem(url: url, kind: .image)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<NoteEditorCubit>();
    final readOnly = cubit.state.readOnly;
    cubit.controller.readOnly = readOnly;
    return PopScope<void>(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) unawaited(_exit());
      },
      child: Column(
        children: [
          EditorHeader(
            onBack: () => unawaited(_exit()),
            onShare: _share,
            onMore: () => unawaited(_openMore()),
          ),
          Expanded(
            child: QuillEditor(
              controller: cubit.controller,
              focusNode: _editorFocus,
              scrollController: _editorScroll,
              config: QuillEditorConfig(
                placeholder: context.l10n.collabNotesBodyHint,
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  AppSpacing.fieldGap,
                  AppSpacing.screen,
                  AppSpacing.xlg,
                ),
                customStyles: noteEditorStyles(context),
                embedBuilders: noteEmbedBuilders(onImageTap: _onImageTap),
                showCursor: true,
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(color: context.colors.canvas),
            child: SafeArea(
              top: false,
              child: NoteToolbar(readOnly: readOnly),
            ),
          ),
        ],
      ),
    );
  }
}
