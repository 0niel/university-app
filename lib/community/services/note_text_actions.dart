import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:share_plus/share_plus.dart';

class NoteTextActions {
  NoteTextActions({
    ProcessTextService? processTextService,
    this.copyText,
    this.shareText,
  }) : _processText = processTextService ?? DefaultProcessTextService();

  final ProcessTextService _processText;
  final Future<void> Function(String)? copyText;
  final Future<void> Function(String, Rect?)? shareText;

  Future<List<ProcessTextAction>> availableActions() async {
    final actions = await _processText.queryTextActions();
    final ids = <String>{};
    return [
      for (final action in actions)
        if (action.id.isNotEmpty &&
            action.label.trim().isNotEmpty &&
            ids.add(action.id))
          action,
    ];
  }

  Future<String?> process(
    ProcessTextAction action,
    String text, {
    required bool readOnly,
  }) => _processText.processTextAction(action.id, text, readOnly);

  Future<void> copy(String text) =>
      copyText?.call(text) ?? Clipboard.setData(ClipboardData(text: text));

  Future<void> share(String text, {Rect? origin}) async {
    final callback = shareText;
    if (callback != null) {
      await callback(text, origin);
      return;
    }
    await SharePlus.instance.share(
      ShareParams(text: text, sharePositionOrigin: origin),
    );
  }
}

class NoteTextSelectionSnapshot {
  NoteTextSelectionSnapshot._(this.start, this.end, this.text, this._document);

  static NoteTextSelectionSnapshot? capture(QuillController controller) {
    final selection = controller.selection;
    if (!selection.isValid || selection.isCollapsed) return null;
    final plainText = controller.document.toPlainText();
    if (selection.start < 0 || selection.end > plainText.length) return null;
    final text = plainText.substring(selection.start, selection.end);
    if (text.trim().isEmpty || text.contains('\uFFFC')) return null;
    return NoteTextSelectionSnapshot._(
      selection.start,
      selection.end,
      text,
      jsonEncode(controller.document.toDelta().toJson()),
    );
  }

  final int start;
  final int end;
  final String text;
  final String _document;

  bool matches(QuillController controller) =>
      controller.selection.start == start &&
      controller.selection.end == end &&
      jsonEncode(controller.document.toDelta().toJson()) == _document;

  bool apply(
    QuillController controller,
    String result, {
    required bool readOnly,
  }) {
    if (readOnly ||
        controller.readOnly ||
        result.trim().isEmpty ||
        !matches(controller)) {
      return false;
    }
    controller.replaceText(
      start,
      end - start,
      result,
      TextSelection.collapsed(offset: start + result.length),
    );
    return true;
  }
}
