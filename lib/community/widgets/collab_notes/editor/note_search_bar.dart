import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/note_document_navigation.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class NoteSearchBar extends StatefulWidget {
  const NoteSearchBar({
    required this.controller,
    required this.onSelected,
    required this.onClose,
    required this.focusNode,
    super.key,
  });
  final QuillController controller;
  final ValueChanged<TextSelection> onSelected;
  final VoidCallback onClose;
  final FocusNode focusNode;
  @override
  State<NoteSearchBar> createState() => _NoteSearchBarState();
}

class _NoteSearchBarState extends State<NoteSearchBar> {
  final _query = TextEditingController();
  var _matches = <TextSelection>[];
  var _index = 0;
  String _documentText = '';

  @override
  void initState() {
    super.initState();
    _documentText = widget.controller.document.toPlainText();
    widget.controller.addListener(_documentChanged);
  }

  void _documentChanged() {
    final text = widget.controller.document.toPlainText();
    if (text == _documentText) return;
    _documentText = text;
    _search(select: false);
  }

  void _search({bool select = true}) {
    setState(() {
      _matches = noteSearchMatches(widget.controller.document, _query.text);
      _index = 0;
    });
    if (select && _matches.isNotEmpty) widget.onSelected(_matches.first);
  }

  void _step(int delta) {
    if (_matches.isEmpty) return;
    setState(() => _index = (_index + delta) % _matches.length);
    widget.onSelected(_matches[_index]);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_documentChanged);
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AppSearchField(
                controller: _query,
                focusNode: widget.focusNode,
                autofocus: true,
                hintText: context.l10n.noteSearchHint,
                onChanged: (_) => _search(),
                onClear: _search,
              ),
            ),
            AppIconButton(
              icon: const AppLineIconWidget(AppLineIcon.close),
              tooltip: MaterialLocalizations.of(context).closeButtonLabel,
              onPressed: widget.onClose,
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                _matches.isEmpty
                    ? context.l10n.noteSearchNoMatches
                    : '${_index + 1} / ${_matches.length}',
                style: AppText.captionSmall.copyWith(
                  color: context.colors.muted,
                ),
              ),
            ),
            AppIconButton(
              icon: const AppLineIconWidget(AppLineIcon.chevronL),
              tooltip: context.l10n.noteSearchPrevious,
              onPressed: _matches.isEmpty ? null : () => _step(-1),
            ),
            AppIconButton(
              icon: const AppLineIconWidget(AppLineIcon.chevronR),
              tooltip: context.l10n.noteSearchNext,
              onPressed: _matches.isEmpty ? null : () => _step(1),
            ),
          ],
        ),
      ],
    ),
  );
}
