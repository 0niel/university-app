import 'dart:async';
import 'dart:convert';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:mime/mime.dart';
import 'package:rtu_mirea_app/common/media_viewer/media_viewer.dart';
import 'package:rtu_mirea_app/community/cubit/note_editor/note_editor.dart';
import 'package:rtu_mirea_app/community/services/note_pdf_export.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/note_document_navigation.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/note_editor_styles.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/note_embed_builders.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/note_image_intake.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/note_outline.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/note_search_bar.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/note_text_tools_sheet.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/note_toolbar.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor_header.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:share_plus/share_plus.dart';

class _NoteFindIntent extends Intent {
  const _NoteFindIntent();
}

class CollabNoteEditorView extends StatefulWidget {
  const CollabNoteEditorView({super.key});

  @override
  State<CollabNoteEditorView> createState() => _CollabNoteEditorViewState();
}

class _CollabNoteEditorViewState extends State<CollabNoteEditorView>
    with WidgetsBindingObserver {
  final _editorFocus = FocusNode();
  final _searchFocus = FocusNode();
  final _editorScroll = ScrollController();
  final _rawEditorKey = GlobalKey<EditorState>();
  var _reading = false;
  var _searching = false;
  var _outline = false;
  var _insertingImage = false;
  var _exiting = false;
  var _exporting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(context.read<NoteEditorCubit>().resynchronize());
    } else if (state == AppLifecycleState.paused) {
      unawaited(_saveOnPause());
    }
  }

  Future<void> _saveOnPause() async {
    final cubit = context.read<NoteEditorCubit>();
    await cubit.persistLocalDraft();
    if (!cubit.isClosed) await cubit.flush();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _editorFocus.dispose();
    _searchFocus.dispose();
    _editorScroll.dispose();
    super.dispose();
  }

  Future<void> _exit() async {
    if (_exiting) return;
    setState(() => _exiting = true);
    final cubit = context.read<NoteEditorCubit>();
    final saved = await cubit.flush().timeout(
      const Duration(seconds: 8),
      onTimeout: () => false,
    );
    if (!mounted) return;
    setState(() => _exiting = false);
    if (saved) {
      Navigator.of(context).pop();
      return;
    }
    if (cubit.canRecoverLocally && await cubit.persistLocalDraft()) {
      if (mounted) Navigator.of(context).pop();
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

  Future<void> _share() async {
    final cubit = context.read<NoteEditorCubit>();
    final title = cubit.state.title.trim();
    final body = cubit.controller.document.toPlainText().trim();
    final text = '$title\n\n$body'.trim();
    if (text.isNotEmpty) {
      try {
        await SharePlus.instance.share(
          ShareParams(
            text: text,
            sharePositionOrigin: _shareOrigin,
          ),
        );
      } on Exception {
        if (mounted) _showToast(context.l10n.noteExportError);
      }
    }
  }

  Future<void> _openMore() async {
    final l10n = context.l10n;
    final canDelete = context.read<NoteEditorCubit>().state.canDelete;
    final action = await showAppSheet<String>(
      context,
      title: context.l10n.more,
      child: AppListGroup(
        children: [
          AppListRow(
            title: l10n.noteSearchHint,
            leading: const AppIconTile(icon: AppLineIcon.search),
            onTap: () =>
                Navigator.of(context, rootNavigator: true).pop('search'),
          ),
          AppListRow(
            title: l10n.noteOutlineTitle,
            leading: const AppIconTile(icon: AppLineIcon.listBulleted),
            onTap: () =>
                Navigator.of(context, rootNavigator: true).pop('outline'),
          ),
          AppListRow(
            title: _reading ? l10n.noteEditingMode : l10n.noteReadingMode,
            leading: const AppIconTile(icon: AppLineIcon.view),
            onTap: () =>
                Navigator.of(context, rootNavigator: true).pop('reading'),
          ),
          AppListRow(
            title: l10n.noteTextToolsTitle,
            leading: const AppIconTile(icon: AppLineIcon.textBold),
            onTap: () => Navigator.of(context, rootNavigator: true).pop('text'),
          ),
          AppListRow(
            title: l10n.share,
            leading: const AppIconTile(icon: AppLineIcon.share),
            onTap: () =>
                Navigator.of(context, rootNavigator: true).pop('share'),
          ),
          AppListRow(
            title: l10n.noteExportDocument,
            leading: const AppIconTile(icon: AppLineIcon.download),
            onTap: () =>
                Navigator.of(context, rootNavigator: true).pop('export'),
          ),
          if (canDelete)
            AppListRow(
              leading: const AppIconTile(icon: AppLineIcon.trash),
              title: context.l10n.collabNotesDelete,
              destructive: true,
              onTap: () =>
                  Navigator.of(context, rootNavigator: true).pop('delete'),
            ),
        ],
      ),
    );
    if (!mounted || action == null) return;
    if (action == 'delete') unawaited(_delete());
    if (action == 'share') unawaited(_share());
    if (action == 'export') unawaited(_export());
    if (action == 'search') _openSearch();
    if (action == 'outline') unawaited(_openOutline());
    if (action == 'reading') _toggleReading();
    if (action == 'text') unawaited(_textTools());
  }

  Rect? get _shareOrigin {
    final box = context.findRenderObject();
    return box is RenderBox && box.hasSize
        ? box.localToGlobal(Offset.zero) & box.size
        : null;
  }

  Future<void> _export() async {
    if (_exporting) return;
    setState(() => _exporting = true);
    final cubit = context.read<NoteEditorCubit>();
    try {
      final data = await exportNotePdf(
        title: cubit.state.title,
        document: cubit.controller.document.toDelta().toJson(),
        attachmentLabel: context.l10n.noteExportAttachment,
      );
      if (!mounted) return;
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(
              data,
              mimeType: 'application/pdf',
            ),
          ],
          fileNameOverrides: const ['note.pdf'],
          sharePositionOrigin: _shareOrigin,
        ),
      );
    } on Object {
      if (mounted) _showToast(context.l10n.noteExportError);
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  void _toggleReading() {
    _editorFocus.unfocus();
    setState(() => _reading = !_reading);
    final cubit = context.read<NoteEditorCubit>();
    cubit.controller.readOnly = _reading || cubit.state.readOnly;
    if (_reading && cubit.state.voiceStatus == NoteVoiceStatus.listening) {
      unawaited(cubit.stopVoiceInput());
    }
  }

  void _openSearch() {
    setState(() => _searching = true);
    _searchFocus.requestFocus();
  }

  Future<void> _textTools() => showNoteTextToolsSheet(
    context,
    controller: context.read<NoteEditorCubit>().controller,
    readOnly: _reading || context.read<NoteEditorCubit>().state.readOnly,
  );

  void _select(TextSelection selection) {
    context.read<NoteEditorCubit>().controller
      ..skipRequestKeyboard = true
      ..updateSelection(selection, ChangeSource.local)
      ..skipRequestKeyboard = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _rawEditorKey.currentState?.bringIntoView(selection.extent);
    });
  }

  Future<void> _openOutline() async {
    if (MediaQuery.sizeOf(context).width >= 1000) {
      setState(() => _outline = !_outline);
      return;
    }
    final heading = await showAppSheet<NoteHeading>(
      context,
      title: context.l10n.noteOutlineTitle,
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * .45,
        child: NoteOutline(
          controller: context.read<NoteEditorCubit>().controller,
          onSelected: (heading) =>
              Navigator.of(context, rootNavigator: true).pop(heading),
        ),
      ),
    );
    if (heading != null && mounted) {
      _select(TextSelection.collapsed(offset: heading.offset));
    }
  }

  Future<void> _insertKeyboardImage(KeyboardInsertedContent content) async {
    final cubit = context.read<NoteEditorCubit>();
    final bytes = content.data;
    if (_insertingImage || _reading || cubit.state.readOnly) return;
    final mime = bytes == null
        ? null
        : lookupMimeType('image', headerBytes: bytes);
    final extension = NoteImageIntake.allowedExtensions[mime];
    if (bytes == null ||
        bytes.isEmpty ||
        bytes.length > NoteImageIntake.maxBytes ||
        extension == null) {
      _showToast(context.l10n.noteImageUploadError);
      return;
    }
    final document = jsonEncode(cubit.controller.document.toDelta().toJson());
    final selection = cubit.controller.selection;
    setState(() => _insertingImage = true);
    try {
      final url = await context.read<CampusRepository>().uploadNoteMedia(
        bytes: bytes,
        contentType: mime!,
        extension: extension,
      );
      if (!mounted || cubit.isClosed) return;
      if (_reading ||
          cubit.state.readOnly ||
          jsonEncode(cubit.controller.document.toDelta().toJson()) !=
              document) {
        _showToast(context.l10n.noteTextToolsChanged);
        return;
      }
      final index = selection.isValid
          ? selection.start.clamp(0, cubit.controller.document.length - 1)
          : cubit.controller.document.length - 1;
      cubit.controller.replaceText(
        index,
        0,
        BlockEmbed.image(url),
        TextSelection.collapsed(offset: index + 1),
      );
    } on Exception {
      if (mounted) _showToast(context.l10n.noteImageUploadError);
    } finally {
      if (mounted) setState(() => _insertingImage = false);
    }
  }

  void _showToast(String message) {
    showNinjaToast(context, showCheck: false, message: message);
  }

  Future<void> _resolveRecovery() async {
    final cubit = context.read<NoteEditorCubit>();
    final keepLocal = await showAppSheet<bool>(
      context,
      title: context.l10n.noteRecoveryReview,
      subtitle: context.l10n.noteRecoveryBody,
      child: AppListGroup(
        children: [
          AppListRow(
            title: context.l10n.noteRecoveryKeepLocal,
            onTap: () => Navigator.of(context, rootNavigator: true).pop(true),
          ),
          AppListRow(
            title: context.l10n.noteRecoveryUseServer,
            onTap: () => Navigator.of(context, rootNavigator: true).pop(false),
          ),
        ],
      ),
    );
    if (!mounted || keepLocal == null) return;
    cubit.resolveRecoveryConflict(keepLocal: keepLocal);
    unawaited(cubit.flush());
  }

  void _onImageTap(String url) {
    final images = <String>[];
    for (final operation
        in context
            .read<NoteEditorCubit>()
            .controller
            .document
            .toDelta()
            .toJson()) {
      final insert = operation['insert'];
      if (insert is Map) {
        final image = insert['image'];
        if (image is String && image.isNotEmpty) images.add(image);
        final drawing = insert['note-drawing'];
        if (drawing is Map) {
          final drawingUrl = drawing['url'];
          if (drawingUrl is String && drawingUrl.isNotEmpty) {
            images.add(drawingUrl);
          }
        }
      }
    }
    if (!images.contains(url)) images.insert(0, url);
    unawaited(
      showMediaViewer(
        context,
        initialIndex: images.indexOf(url),
        items: [
          for (final image in images) MediaItem(url: image, kind: .image),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NoteEditorCubit>();
    final locked = context.select<NoteEditorCubit, bool>(
      (cubit) => cubit.state.readOnly,
    );
    final readOnly = locked || _reading;
    cubit.controller.readOnly = readOnly;
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyF, control: true):
            _openSearch,
        const SingleActivator(LogicalKeyboardKey.keyF, meta: true): _openSearch,
        const SingleActivator(LogicalKeyboardKey.keyS, control: true): () =>
            unawaited(cubit.flush()),
        const SingleActivator(LogicalKeyboardKey.keyS, meta: true): () =>
            unawaited(cubit.flush()),
      },
      child: PopScope<void>(
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
              reading: _reading,
              onReading: _toggleReading,
            ),
            BlocBuilder<NoteEditorCubit, NoteEditorState>(
              buildWhen: (previous, current) =>
                  previous.status != current.status,
              builder: (context, state) {
                if (!cubit.hasRecoveryConflict) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: AppBanner(
                    message: context.l10n.noteRecoveryConflict,
                    tone: AppBannerTone.warn,
                    actionLabel: context.l10n.noteRecoveryReview,
                    onAction: () => unawaited(_resolveRecovery()),
                  ),
                );
              },
            ),
            if (_searching)
              NoteSearchBar(
                focusNode: _searchFocus,
                controller: cubit.controller,
                onSelected: _select,
                onClose: () => setState(() => _searching = false),
              ),
            if (_insertingImage || _exiting || _exporting)
              const LinearProgressIndicator(minHeight: 2),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_outline && constraints.maxWidth >= 1000)
                      SizedBox(
                        width: 248,
                        child: NoteOutline(
                          controller: cubit.controller,
                          onSelected: (heading) => _select(
                            TextSelection.collapsed(offset: heading.offset),
                          ),
                        ),
                      ),
                    Expanded(
                      child: ColoredBox(
                        color: context.colors.surface,
                        child: QuillEditor(
                          controller: cubit.controller,
                          focusNode: _editorFocus,
                          scrollController: _editorScroll,
                          config: QuillEditorConfig(
                            customShortcuts: const {
                              SingleActivator(
                                LogicalKeyboardKey.keyF,
                                control: true,
                              ): _NoteFindIntent(),
                              SingleActivator(
                                LogicalKeyboardKey.keyF,
                                meta: true,
                              ): _NoteFindIntent(),
                            },
                            customActions: {
                              _NoteFindIntent: CallbackAction<_NoteFindIntent>(
                                onInvoke: (_) {
                                  _openSearch();
                                  return null;
                                },
                              ),
                            },
                            editorKey: _rawEditorKey,
                            maxContentWidth: 820,
                            enableScribble: !readOnly,
                            checkBoxReadOnly: readOnly,
                            keyboardAppearance: Theme.of(context).brightness,
                            scrollPhysics: const ClampingScrollPhysics(),
                            contextMenuBuilder: (menuContext, editor) =>
                                AdaptiveTextSelectionToolbar.buttonItems(
                                  anchors: editor.contextMenuAnchors,
                                  buttonItems: [
                                    ...editor.contextMenuButtonItems,
                                    if (!cubit.controller.selection.isCollapsed)
                                      ContextMenuButtonItem(
                                        label: context.l10n.noteTextToolsTitle,
                                        onPressed: () {
                                          ContextMenuController.removeAny();
                                          unawaited(_textTools());
                                        },
                                      ),
                                  ],
                                ),
                            contentInsertionConfiguration: readOnly
                                ? null
                                : ContentInsertionConfiguration(
                                    allowedMimeTypes: NoteImageIntake
                                        .allowedExtensions
                                        .keys
                                        .toList(),
                                    onContentInserted: (content) => unawaited(
                                      _insertKeyboardImage(content),
                                    ),
                                  ),
                            placeholder: context.l10n.collabNotesBodyHint,
                            padding: const EdgeInsets.fromLTRB(
                              AppSpacing.screen,
                              AppSpacing.fieldGap,
                              AppSpacing.screen,
                              AppSpacing.xlg,
                            ),
                            customStyles: noteEditorStyles(context),
                            embedBuilders: noteEmbedBuilders(
                              onImageTap: _onImageTap,
                            ),
                            showCursor: !readOnly,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (!readOnly)
              DecoratedBox(
                decoration: BoxDecoration(color: context.colors.canvas),
                child: SafeArea(
                  top: false,
                  child: NoteToolbar(readOnly: readOnly),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
