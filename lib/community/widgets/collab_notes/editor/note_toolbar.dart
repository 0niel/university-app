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

  void _toggle(Attribute<dynamic> attribute) {
    final active = _has(attribute);
    _controller.formatSelection(
      active ? Attribute.clone(attribute, null) : attribute,
    );
  }

  void _setHeader(int level) {
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
    final hasSelection = !_controller.selection.isCollapsed;
    final input = await showNoteLinkSheet(
      context,
      showTextField: !hasSelection,
    );
    if (input == null || !mounted) return;
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
  }

  Future<void> _pickColor({required bool highlight}) async {
    final color = await showNoteColorSheet(
      context,
      title: highlight
          ? context.l10n.noteToolbarHighlight
          : context.l10n.noteToolbarColor,
    );
    if (!mounted) return;
    final hex = color == null ? null : _colorHex(color);
    _controller.formatSelection(
      highlight ? BackgroundAttribute(hex) : ColorAttribute(hex),
    );
  }

  String _colorHex(Color color) =>
      '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

  Future<void> _addImage() async {
    final source = await showNoteImageSourceSheet(context);
    if (source == null || !mounted) return;
    final file = await ImagePicker().pickImage(
      source: source,
      imageQuality: 90,
    );
    if (file == null || !mounted) return;
    final upload = await NoteImageIntake.read(file);
    if (!mounted) return;
    if (upload == null) {
      _showToast(context.l10n.noteImageUploadError);
      return;
    }
    _showToast(context.l10n.noteImageUploading, checked: false);
    try {
      final repository = context.read<CampusRepository>();
      final url = await repository.uploadNoteMedia(
        bytes: upload.bytes,
        contentType: upload.contentType,
        extension: upload.extension,
      );
      if (!mounted) return;
      context.read<NoteEditorCubit>().insertImage(url);
    } on Exception {
      if (mounted) _showToast(context.l10n.noteImageUploadError);
    }
  }

  Future<void> _addDrawing() async {
    final result = await showCollabNoteDrawingPage(context);
    if (result == null || !mounted) return;
    try {
      final repository = context.read<CampusRepository>();
      final url = await repository.uploadNoteMedia(
        bytes: result.bytes,
        contentType: 'image/png',
        extension: 'png',
      );
      if (!mounted) return;
      context.read<NoteEditorCubit>().insertDrawing(
        url: url,
        strokesJson: result.strokesJson,
      );
    } on Exception {
      if (mounted) _showToast(context.l10n.noteImageUploadError);
    }
  }

  Future<void> _toggleVoice(NoteEditorState state) async {
    final cubit = context.read<NoteEditorCubit>();
    if (state.voiceStatus == .listening) {
      await cubit.stopVoiceInput();
      return;
    }
    final allowed = await showNoteVoicePermissionSheet(context);
    if (!mounted) return;
    if (!allowed) return;
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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final voiceStatus = context.watch<NoteEditorCubit>().state.voiceStatus;
    final disabled = widget.readOnly;
    return SizedBox(
      height: AppControlSize.iconButtonCompact + AppSpacing.md,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screen,
          vertical: AppSpacing.xs,
        ),
        children: [
          NoteToolbarButton(
            icon: .mic,
            active: voiceStatus == .listening,
            semanticsLabel: l10n.noteToolbarMic,
            enabled: !disabled,
            onTap: () => unawaited(
              _toggleVoice(context.read<NoteEditorCubit>().state),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          NoteToolbarButton(
            icon: .image,
            semanticsLabel: l10n.noteToolbarImage,
            enabled: !disabled,
            onTap: () => unawaited(_addImage()),
          ),
          const SizedBox(width: AppSpacing.sm),
          NoteToolbarButton(
            icon: .brush,
            semanticsLabel: l10n.noteToolbarDrawing,
            enabled: !disabled,
            onTap: () => unawaited(_addDrawing()),
          ),
          const NoteToolbarGap(),
          NoteToolbarButton(
            icon: .undo,
            semanticsLabel: l10n.noteToolbarUndo,
            enabled: !disabled && _controller.hasUndo,
            onTap: _controller.undo,
          ),
          const SizedBox(width: AppSpacing.sm),
          NoteToolbarButton(
            icon: .redo,
            semanticsLabel: l10n.noteToolbarRedo,
            enabled: !disabled && _controller.hasRedo,
            onTap: _controller.redo,
          ),
          const NoteToolbarGap(),
          NoteToolbarButton(
            icon: .textBold,
            active: _has(Attribute.bold),
            semanticsLabel: l10n.noteToolbarBold,
            enabled: !disabled,
            onTap: () => _toggle(Attribute.bold),
          ),
          const SizedBox(width: AppSpacing.sm),
          NoteToolbarButton(
            icon: .textItalic,
            active: _has(Attribute.italic),
            semanticsLabel: l10n.noteToolbarItalic,
            enabled: !disabled,
            onTap: () => _toggle(Attribute.italic),
          ),
          const SizedBox(width: AppSpacing.sm),
          NoteToolbarButton(
            icon: .textUnderline,
            active: _has(Attribute.underline),
            semanticsLabel: l10n.noteToolbarUnderline,
            enabled: !disabled,
            onTap: () => _toggle(Attribute.underline),
          ),
          const SizedBox(width: AppSpacing.sm),
          NoteToolbarButton(
            icon: .textStrike,
            active: _has(Attribute.strikeThrough),
            semanticsLabel: l10n.noteToolbarStrike,
            enabled: !disabled,
            onTap: () => _toggle(Attribute.strikeThrough),
          ),
          const NoteToolbarGap(),
          for (final level in const [1, 2, 3]) ...[
            NoteToolbarButton(
              icon: .headerLevel,
              active: _headerLevel() == level,
              semanticsLabel: switch (level) {
                1 => l10n.noteToolbarHeading1,
                2 => l10n.noteToolbarHeading2,
                _ => l10n.noteToolbarHeading3,
              },
              enabled: !disabled,
              onTap: () => _setHeader(level),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          const NoteToolbarGap(),
          NoteToolbarButton(
            icon: .listBulleted,
            active: _listValue() == 'bullet',
            semanticsLabel: l10n.noteToolbarBulletList,
            enabled: !disabled,
            onTap: () => _setList('bullet'),
          ),
          const SizedBox(width: AppSpacing.sm),
          NoteToolbarButton(
            icon: .listNumbered,
            active: _listValue() == 'ordered',
            semanticsLabel: l10n.noteToolbarNumberedList,
            enabled: !disabled,
            onTap: () => _setList('ordered'),
          ),
          const SizedBox(width: AppSpacing.sm),
          NoteToolbarButton(
            icon: .listCheck,
            active: _listValue() == 'unchecked' || _listValue() == 'checked',
            semanticsLabel: l10n.noteToolbarChecklist,
            enabled: !disabled,
            onTap: () => _setList('unchecked'),
          ),
          const NoteToolbarGap(),
          NoteToolbarButton(
            icon: .quote,
            active: _has(Attribute.blockQuote),
            semanticsLabel: l10n.noteToolbarQuote,
            enabled: !disabled,
            onTap: () => _toggle(Attribute.blockQuote),
          ),
          const SizedBox(width: AppSpacing.sm),
          NoteToolbarButton(
            icon: .codeBlock,
            active: _has(Attribute.codeBlock),
            semanticsLabel: l10n.noteToolbarCodeBlock,
            enabled: !disabled,
            onTap: () => _toggle(Attribute.codeBlock),
          ),
          const SizedBox(width: AppSpacing.sm),
          NoteToolbarButton(
            icon: .link,
            active: _has(Attribute.link),
            semanticsLabel: l10n.noteToolbarLink,
            enabled: !disabled,
            onTap: () => unawaited(_insertLink()),
          ),
          const NoteToolbarGap(),
          NoteToolbarButton(
            icon: .palette,
            semanticsLabel: l10n.noteToolbarColor,
            enabled: !disabled,
            onTap: () => unawaited(_pickColor(highlight: false)),
          ),
          const SizedBox(width: AppSpacing.sm),
          NoteToolbarButton(
            icon: .palette,
            semanticsLabel: l10n.noteToolbarHighlight,
            enabled: !disabled,
            onTap: () => unawaited(_pickColor(highlight: true)),
          ),
        ],
      ),
    );
  }
}
