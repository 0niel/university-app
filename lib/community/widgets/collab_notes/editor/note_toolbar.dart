import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rtu_mirea_app/community/cubit/note_editor/note_editor.dart';
import 'package:rtu_mirea_app/community/view/collab_note_drawing_page.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/note_color_sheet.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/note_image_intake.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/note_image_source_sheet.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/note_link_sheet.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/note_toolbar_button.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/note_voice_permission_sheet.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class NoteToolbar extends StatefulWidget {
  const NoteToolbar({required this.readOnly, super.key});

  final bool readOnly;

  @override
  State<NoteToolbar> createState() => _NoteToolbarState();
}

class _NoteToolbarState extends State<NoteToolbar> {
  late final QuillController _controller = context
      .read<NoteEditorCubit>()
      .controller;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  bool _has(Attribute<dynamic> attribute) =>
      _controller.getSelectionStyle().attributes.containsKey(attribute.key);

  int? _headerLevel() {
    final style = _controller.getSelectionStyle().attributes;
    final value = style[Attribute.header.key]?.value;
    return value is int ? value : null;
  }

  String? _listValue() {
    final style = _controller.getSelectionStyle().attributes;
    final value = style[Attribute.list.key]?.value;
    return value is String ? value : null;
  }

  bool get _canEdit => mounted && !widget.readOnly && !_controller.readOnly;

  void _toggle(Attribute<dynamic> attribute) {
    if (!_canEdit) return;
    final active = _has(attribute);
    _controller.formatSelection(
      active ? Attribute.clone(attribute, null) : attribute,
    );
  }

  void _setHeader(int level) {
    if (!_canEdit) return;
    final current = _headerLevel();
    final target = switch (level) {
      1 => Attribute.h1,
      2 => Attribute.h2,
      _ => Attribute.h3,
    };
    _controller.formatSelection(
      current == level ? Attribute.clone(Attribute.header, null) : target,
    );
  }

  void _setList(String value) {
    if (!_canEdit) return;
    final current = _listValue();
    _controller.formatSelection(
      current == value
          ? Attribute.clone(Attribute.list, null)
          : ListAttribute(value),
    );
  }

  int _insertionIndex() {
    final offset = _controller.selection.baseOffset;
    return offset < 0 ? _controller.document.length - 1 : offset;
  }

  Future<void> _insertLink() async {
    if (!_canEdit) return;
    final bookmark = _NoteSelectionBookmark(_controller);
    final hasSelection = !_controller.selection.isCollapsed;
    final currentLink = _controller
        .getSelectionStyle()
        .attributes[Attribute.link.key]
        ?.value;
    try {
      final input = await showNoteLinkSheet(
        context,
        initialUrl: currentLink is String ? currentLink : '',
        showTextField: !hasSelection,
      );
      if (input == null || !_canEdit) return;
      bookmark.restore();
      if (hasSelection) {
        _controller.formatSelection(LinkAttribute(input.url));
        return;
      }
      final index = _insertionIndex();
      _controller
        ..replaceText(
          index,
          0,
          input.text,
          TextSelection.collapsed(offset: index + input.text.length),
        )
        ..formatText(index, input.text.length, LinkAttribute(input.url));
    } finally {
      await bookmark.dispose();
    }
  }

  Future<void> _pickColor({required bool highlight}) async {
    if (!_canEdit) return;
    final bookmark = _NoteSelectionBookmark(_controller);
    final attribute = highlight ? Attribute.background : Attribute.color;
    final value = _controller
        .getSelectionStyle()
        .attributes[attribute.key]
        ?.value;
    final hexValue = value is String
        ? int.tryParse(value.replaceFirst('#', ''), radix: 16)
        : null;
    try {
      final selection = await showNoteColorSheet(
        context,
        title: highlight
            ? context.l10n.noteToolbarHighlight
            : context.l10n.noteToolbarColor,
        initialColor: hexValue == null ? null : Color(0xFF000000 | hexValue),
      );
      if (selection == null || !_canEdit) return;
      bookmark.restore();
      final color = selection.color;
      final hex = color == null ? null : _colorHex(color);
      _controller.formatSelection(
        highlight ? BackgroundAttribute(hex) : ColorAttribute(hex),
      );
    } finally {
      await bookmark.dispose();
    }
  }

  String _colorHex(Color color) =>
      '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

  Future<void> _addImage() async {
    if (!mounted || !_canEdit) return;
    final bookmark = _NoteSelectionBookmark(_controller);
    try {
      final source = await showNoteImageSourceSheet(context);
      if (source == null || !mounted || !_canEdit) return;
      final file = await ImagePicker().pickImage(
        source: source,
        imageQuality: 90,
      );
      if (file == null || !mounted || !_canEdit) return;
      final upload = await NoteImageIntake.read(file);
      if (!mounted || !_canEdit) return;
      if (upload == null) {
        _showToast(context.l10n.noteImageUploadError);
        return;
      }
      _showToast(context.l10n.noteImageUploading, checked: false);
      final url = await context.read<CampusRepository>().uploadNoteMedia(
        bytes: upload.bytes,
        contentType: upload.contentType,
        extension: upload.extension,
      );
      if (!mounted || !_canEdit) return;
      bookmark.restore();
      context.read<NoteEditorCubit>().insertImage(url);
    } on Exception {
      if (mounted) _showToast(context.l10n.noteImageUploadError);
    } finally {
      await bookmark.dispose();
    }
  }

  Future<void> _addDrawing() async {
    if (!mounted || !_canEdit) return;
    final bookmark = _NoteSelectionBookmark(_controller);
    try {
      final result = await showCollabNoteDrawingPage(context);
      if (result == null || !mounted || !_canEdit) return;
      final url = await context.read<CampusRepository>().uploadNoteMedia(
        bytes: result.bytes,
        contentType: 'image/png',
        extension: 'png',
      );
      if (!mounted || !_canEdit) return;
      bookmark.restore();
      context.read<NoteEditorCubit>().insertDrawing(
        url: url,
        strokesJson: result.strokesJson,
      );
    } on Exception {
      if (mounted) _showToast(context.l10n.noteImageUploadError);
    } finally {
      await bookmark.dispose();
    }
  }

  Future<void> _toggleVoice(NoteEditorState state) async {
    if (!_canEdit) return;
    final cubit = context.read<NoteEditorCubit>();
    if (state.voiceStatus == .listening) {
      await cubit.stopVoiceInput();
      return;
    }
    final allowed = await showNoteVoicePermissionSheet(context);
    if (!mounted) return;
    if (!allowed || !_canEdit) return;
    final mutedHex = _colorHex(context.colors.muted);
    await cubit.startVoiceInput(mutedColorHex: mutedHex);
    if (!mounted) return;
    final voiceStatus = cubit.state.voiceStatus;
    if (voiceStatus == .unavailable) {
      _showToast(context.l10n.noteVoiceUnavailable);
    } else if (voiceStatus == .error) {
      _showToast(context.l10n.noteVoiceError);
    }
  }

  void _showToast(String message, {bool checked = true}) {
    showNinjaToast(context, showCheck: checked, message: message);
  }

  Future<void> _showActions(
    String title,
    List<_NoteToolbarAction> actions,
  ) async {
    if (!_canEdit) return;
    final bookmark = _NoteSelectionBookmark(_controller);
    final focus = FocusManager.instance.primaryFocus;
    try {
      final action = await showAppSheet<_NoteToolbarAction>(
        context,
        title: title,
        child: AppListGroup(
          children: [
            for (final (index, action) in actions.indexed)
              AppListRow(
                title: action.label,
                leading: AppLineIconWidget(action.icon),
                trailing: action.active
                    ? const AppLineIconWidget(AppLineIcon.check)
                    : null,
                showChevron: false,
                isFirst: index == 0,
                onTap: () =>
                    Navigator.of(context, rootNavigator: true).pop(action),
              ),
          ],
        ),
      );
      if (!_canEdit) return;
      bookmark.restore();
      if (action != null) await action.run();
      if (_canEdit && focus?.context != null) focus!.requestFocus();
    } finally {
      await bookmark.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final voiceStatus = context.select<NoteEditorCubit, NoteVoiceStatus>(
      (cubit) => cubit.state.voiceStatus,
    );
    final voiceActive = voiceStatus == .listening;
    final style = _controller.getSelectionStyle().attributes;
    bool has(Attribute<dynamic> attribute) => style.containsKey(attribute.key);
    final headerLevel = style[Attribute.header.key]?.value;
    final listValue = style[Attribute.list.key]?.value;
    final disabled = widget.readOnly || _controller.readOnly;
    final formatting = <_NoteToolbarAction>[
      _NoteToolbarAction(
        .textBold,
        l10n.noteToolbarBold,
        () => _toggle(Attribute.bold),
        active: has(Attribute.bold),
      ),
      _NoteToolbarAction(
        .textItalic,
        l10n.noteToolbarItalic,
        () => _toggle(Attribute.italic),
        active: has(Attribute.italic),
      ),
      _NoteToolbarAction(
        .textUnderline,
        l10n.noteToolbarUnderline,
        () => _toggle(Attribute.underline),
        active: has(Attribute.underline),
      ),
      _NoteToolbarAction(
        .textStrike,
        l10n.noteToolbarStrike,
        () => _toggle(Attribute.strikeThrough),
        active: has(Attribute.strikeThrough),
      ),
      for (final level in [1, 2, 3])
        _NoteToolbarAction(
          .headerLevel,
          switch (level) {
            1 => l10n.noteToolbarHeading1,
            2 => l10n.noteToolbarHeading2,
            _ => l10n.noteToolbarHeading3,
          },
          () => _setHeader(level),
          active: headerLevel == level,
        ),
      _NoteToolbarAction(
        .listBulleted,
        l10n.noteToolbarBulletList,
        () => _setList('bullet'),
        active: listValue == 'bullet',
      ),
      _NoteToolbarAction(
        .listNumbered,
        l10n.noteToolbarNumberedList,
        () => _setList('ordered'),
        active: listValue == 'ordered',
      ),
      _NoteToolbarAction(
        .listCheck,
        l10n.noteToolbarChecklist,
        () => _setList('unchecked'),
        active: listValue == 'checked' || listValue == 'unchecked',
      ),
      _NoteToolbarAction(
        .quote,
        l10n.noteToolbarQuote,
        () => _toggle(Attribute.blockQuote),
        active: has(Attribute.blockQuote),
      ),
      _NoteToolbarAction(
        .codeBlock,
        l10n.noteToolbarCodeBlock,
        () => _toggle(Attribute.codeBlock),
        active: has(Attribute.codeBlock),
      ),
      _NoteToolbarAction(
        .palette,
        l10n.noteToolbarColor,
        () => _pickColor(highlight: false),
        active: has(Attribute.color),
      ),
      _NoteToolbarAction(
        .palette,
        l10n.noteToolbarHighlight,
        () => _pickColor(highlight: true),
        active: has(Attribute.background),
      ),
    ];
    final inserting = <_NoteToolbarAction>[
      _NoteToolbarAction(
        .link,
        l10n.noteToolbarLink,
        _insertLink,
        active: has(Attribute.link),
      ),
      _NoteToolbarAction(.image, l10n.noteToolbarImage, _addImage),
      _NoteToolbarAction(.brush, l10n.noteToolbarDrawing, _addDrawing),
      _NoteToolbarAction(
        .mic,
        l10n.noteToolbarMic,
        () => _toggleVoice(context.read<NoteEditorCubit>().state),
        active: voiceActive,
      ),
    ];
    return TextFieldTapRegion(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final expanded = constraints.maxWidth >= 720;
          final buttons = <Widget>[
            NoteToolbarButton(
              icon: .undo,
              semanticsLabel: l10n.noteToolbarUndo,
              enabled: !disabled && _controller.hasUndo,
              onTap: () {
                if (_canEdit) _controller.undo();
              },
            ),
            NoteToolbarButton(
              icon: .redo,
              semanticsLabel: l10n.noteToolbarRedo,
              enabled: !disabled && _controller.hasRedo,
              onTap: () {
                if (_canEdit) _controller.redo();
              },
            ),
            for (final action in formatting.take(expanded ? 3 : 2))
              NoteToolbarButton(
                icon: action.icon,
                semanticsLabel: action.label,
                active: action.active,
                enabled: !disabled,
                onTap: () => unawaited(Future.sync(action.run)),
              ),
            if (expanded) ...[
              for (final action in [
                formatting[7],
                formatting[9],
                ...inserting.skip(1),
              ])
                NoteToolbarButton(
                  icon: action.icon,
                  semanticsLabel: action.label,
                  active: action.active,
                  enabled: !disabled,
                  onTap: () => unawaited(Future.sync(action.run)),
                ),
            ],
            NoteToolbarButton(
              icon: .more,
              semanticsLabel: l10n.noteToolbarFormat,
              enabled: !disabled,
              onTap: () =>
                  unawaited(_showActions(l10n.noteToolbarFormat, formatting)),
            ),
            NoteToolbarButton(
              icon: .plus,
              semanticsLabel: l10n.noteToolbarInsert,
              active: voiceActive,
              enabled: !disabled,
              onTap: () =>
                  unawaited(_showActions(l10n.noteToolbarInsert, inserting)),
            ),
          ];
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xxs,
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: AppSpacing.xxs,
              children: buttons,
            ),
          );
        },
      ),
    );
  }
}

class _NoteToolbarAction {
  const _NoteToolbarAction(
    this.icon,
    this.label,
    this.run, {
    this.active = false,
  });

  final AppLineIcon icon;
  final String label;
  final FutureOr<void> Function() run;
  final bool active;
}

class _NoteSelectionBookmark {
  _NoteSelectionBookmark(this.controller) : selection = controller.selection {
    subscription = controller.document.changes.listen((event) {
      selection = TextSelection(
        baseOffset: event.change.transformPosition(selection.baseOffset),
        extentOffset: event.change.transformPosition(selection.extentOffset),
      );
    });
  }

  final QuillController controller;
  TextSelection selection;
  late final StreamSubscription<DocChange> subscription;

  void restore() {
    final end = controller.document.length - 1;
    controller
      ..skipRequestKeyboard = true
      ..updateSelection(
        TextSelection(
          baseOffset: selection.baseOffset.clamp(0, end),
          extentOffset: selection.extentOffset.clamp(0, end),
        ),
        ChangeSource.local,
      );
  }

  Future<void> dispose() => subscription.cancel();
}
