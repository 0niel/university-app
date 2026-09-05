import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:rtu_mirea_app/community/services/note_text_actions.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

Future<void> showNoteTextToolsSheet(
  BuildContext context, {
  required QuillController controller,
  required bool readOnly,
  NoteTextActions? actions,
}) async {
  final snapshot = NoteTextSelectionSnapshot.capture(controller);
  if (snapshot == null) {
    showNinjaToast(
      context,
      message: context.l10n.noteTextToolsSelectText,
      showCheck: false,
    );
    return;
  }
  await showAppSheet<void>(
    context,
    title: context.l10n.noteTextToolsTitle,
    child: NoteTextToolsSheet(
      controller: controller,
      readOnly: readOnly,
      snapshot: snapshot,
      actions: actions ?? NoteTextActions(),
    ),
  );
}

class NoteTextToolsSheet extends StatefulWidget {
  const NoteTextToolsSheet({
    required this.controller,
    required this.readOnly,
    required this.snapshot,
    required this.actions,
    super.key,
  });

  final QuillController controller;
  final bool readOnly;
  final NoteTextSelectionSnapshot snapshot;
  final NoteTextActions actions;

  @override
  State<NoteTextToolsSheet> createState() => _NoteTextToolsSheetState();
}

class _NoteTextToolsSheetState extends State<NoteTextToolsSheet> {
  var _loading = true;
  var _working = false;
  var _failed = false;
  var _noResult = false;
  var _sourceChanged = false;
  List<ProcessTextAction> _actions = [];
  String? _result;
  StreamSubscription<DocChange>? _documentChanges;

  bool get _readOnly => widget.readOnly || widget.controller.readOnly;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_checkSource);
    _documentChanges = widget.controller.changes.listen((_) {
      if (mounted && !_sourceChanged) {
        setState(() => _sourceChanged = true);
      }
    });
    unawaited(_loadActions());
  }

  @override
  void dispose() {
    widget.controller.removeListener(_checkSource);
    unawaited(_documentChanges?.cancel());
    super.dispose();
  }

  void _checkSource() {
    if (!mounted || _sourceChanged) return;
    if (!widget.snapshot.matches(widget.controller)) {
      setState(() => _sourceChanged = true);
    }
  }

  Future<void> _loadActions() async {
    try {
      final actions = await widget.actions.availableActions();
      if (!mounted) return;
      setState(() {
        _actions = actions;
        _loading = false;
      });
    } on Exception {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _failed = true;
      });
    }
  }

  Future<void> _process(ProcessTextAction action) async {
    if (_working) return;
    setState(() {
      _working = true;
      _failed = false;
      _noResult = false;
      _result = null;
    });
    try {
      final result = await widget.actions.process(
        action,
        widget.snapshot.text,
        readOnly: _readOnly,
      );
      if (!mounted) return;
      _checkSource();
      setState(() {
        _working = false;
        _noResult = result == null || result.trim().isEmpty;
        _result = _noResult ? null : result;
      });
    } on Exception {
      if (!mounted) return;
      setState(() {
        _working = false;
        _failed = true;
      });
    }
  }

  Future<void> _copy() async {
    try {
      await widget.actions.copy(_result ?? widget.snapshot.text);
      if (!mounted) return;
      showNinjaToast(context, message: context.l10n.noteTextToolsCopied);
    } on Exception {
      if (mounted) setState(() => _failed = true);
    }
  }

  Future<void> _share() async {
    try {
      final box = context.findRenderObject() as RenderBox?;
      final origin = box == null
          ? null
          : box.localToGlobal(Offset.zero) & box.size;
      await widget.actions.share(
        _result ?? widget.snapshot.text,
        origin: origin,
      );
    } on Exception {
      if (mounted) setState(() => _failed = true);
    }
  }

  void _apply() {
    final result = _result;
    if (result == null || _sourceChanged) return;
    if (_readOnly) {
      setState(() {});
      return;
    }
    if (!widget.snapshot.apply(
      widget.controller,
      result,
      readOnly: _readOnly,
    )) {
      setState(() => _sourceChanged = true);
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final result = _result;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.noteTextToolsDescription,
          style: AppText.body.copyWith(color: colors.muted),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          widget.snapshot.text,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: AppText.body,
        ),
        const SizedBox(height: AppSpacing.md),
        if (_loading || _working)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Row(
              children: [
                const AppSpinner(),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    _working
                        ? l10n.noteTextToolsWorking
                        : l10n.noteTextToolsLoading,
                    style: AppText.body,
                  ),
                ),
              ],
            ),
          )
        else if (_actions.isEmpty && !_failed)
          Text(l10n.noteTextToolsUnavailable, style: AppText.body),
        if (_actions.isNotEmpty)
          AppListGroup(
            children: [
              for (final (index, action) in _actions.indexed)
                AppListRow(
                  key: ValueKey('note-text-action-${action.id}'),
                  title: action.label,
                  leading: const AppIconTile(icon: AppLineIcon.external),
                  isFirst: index == 0,
                  onTap: _working ? null : () => unawaited(_process(action)),
                ),
            ],
          ),
        if (_failed || _noResult) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            _failed ? l10n.noteTextToolsFailure : l10n.noteTextToolsNoResult,
            style: AppText.body.copyWith(color: colors.muted),
          ),
        ],
        if (result != null) ...[
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.noteTextToolsPreview, style: AppText.bodyStrong),
          const SizedBox(height: AppSpacing.sm),
          SelectableText(
            result,
            key: const ValueKey('note-text-result'),
            style: AppText.body,
          ),
          const SizedBox(height: AppSpacing.md),
          if (_sourceChanged || _readOnly)
            Text(
              _readOnly
                  ? l10n.noteTextToolsReadOnly
                  : l10n.noteTextToolsChanged,
              style: AppText.body.copyWith(color: colors.muted),
            )
          else
            AppButton.primary(
              key: const ValueKey('note-text-apply'),
              label: l10n.noteTextToolsApply,
              expanded: true,
              onPressed: _apply,
            ),
        ],
        const SizedBox(height: AppSpacing.md),
        AppListGroup(
          children: [
            AppListRow(
              key: const ValueKey('note-text-copy'),
              title: l10n.noteTextToolsCopy,
              leading: const AppIconTile(icon: AppLineIcon.clipboard),
              showChevron: false,
              isFirst: true,
              onTap: () => unawaited(_copy()),
            ),
            AppListRow(
              key: const ValueKey('note-text-share'),
              title: l10n.noteTextToolsShare,
              leading: const AppIconTile(icon: AppLineIcon.share),
              showChevron: false,
              onTap: () => unawaited(_share()),
            ),
          ],
        ),
      ],
    );
  }
}
