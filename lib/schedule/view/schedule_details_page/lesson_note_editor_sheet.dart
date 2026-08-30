part of '../schedule_details_page.dart';

class _LessonNoteEditorSheet extends StatefulWidget {
  const _LessonNoteEditorSheet({
    required this.initialText,
    required this.initialShared,
    required this.subtitle,
    required this.accent,
    required this.onChanged,
    required this.onDone,
    this.room,
    this.groupName,
  });
  final String initialText;
  final bool initialShared;
  final String subtitle;
  final Color accent;
  final String? room;
  final String? groupName;
  final void Function({required String text, required bool shared}) onChanged;
  final void Function({required String text, required bool shared}) onDone;
  @override
  State<_LessonNoteEditorSheet> createState() => _LessonNoteEditorSheetState();
}

class _LessonNoteEditorSheetState extends State<_LessonNoteEditorSheet> {
  late final _HashtagTextController _controller = _HashtagTextController(
    accent: widget.accent,
    text: widget.initialText,
  );
  late bool _shared = widget.initialShared;
  Timer? _debounce;
  Timer? _savedVisibilityTimer;
  bool _savedShown = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scheduleSave);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _savedVisibilityTimer?.cancel();
    _controller
      ..removeListener(_scheduleSave)
      ..dispose();
    super.dispose();
  }

  void _scheduleSave() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onChanged(text: _controller.text.trim(), shared: _shared);
      if (!mounted) return;
      setState(() => _savedShown = true);
      _savedVisibilityTimer?.cancel();
      _savedVisibilityTimer = Timer(const Duration(milliseconds: 1400), () {
        if (mounted) setState(() => _savedShown = false);
      });
    });
  }

  void _toggleShared() {
    setState(() => _shared = !_shared);
    _scheduleSave();
  }

  void _insert(String snippet) {
    final selection = _controller.selection;
    final text = _controller.text;
    final start = selection.start >= 0 ? selection.start : text.length;
    final end = selection.end >= 0 ? selection.end : start;
    final next = text.replaceRange(start, end, snippet);
    _controller.value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: start + snippet.length),
    );
  }

  void _done() {
    widget.onDone(text: _controller.text.trim(), shared: _shared);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final groupName = widget.groupName;
    final shareSub = groupName == null
        ? l10n.noteShareWithGroupGeneric
        : l10n.noteShareWithGroupSub(groupName);
    return Column(
      mainAxisSize: .min,
      children: [
        Padding(
          padding: const .fromLTRB(18, 0, 18, 12),
          child: Row(
            children: [
              AppPressable(
                onTap: () => Navigator.of(context).maybePop(),
                semanticsLabel: l10n.cancel,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 72,
                    minHeight: 44,
                  ),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      l10n.cancel,
                      style: NinjaText.body.copyWith(color: colors.muted),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      l10n.noteEditorTitle,
                      style: NinjaText.body.copyWith(
                        color: colors.ink,
                        fontWeight: .w700,
                      ),
                    ),
                    Text(
                      widget.subtitle,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: NinjaText.helper.copyWith(
                        color: colors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              AppPressable(
                onTap: _done,
                semanticsLabel: l10n.noteEditorDone,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 72,
                    minHeight: 44,
                  ),
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(
                      l10n.noteEditorDone,
                      textAlign: .right,
                      style: NinjaText.body.copyWith(
                        color: colors.brandInk,
                        fontWeight: .w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Flexible(
          child: SingleChildScrollView(
            padding: const .fromLTRB(18, 16, 18, 12),
            child: Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              children: [
                if (widget.room case final room?) ...[
                  Container(
                    padding: const .symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: colors.surfaceAlt,
                      borderRadius: .circular(NinjaRadius.pill),
                    ),
                    child: Row(
                      mainAxisSize: .min,
                      spacing: 7,
                      children: [
                        AppLineIconWidget(
                          .pin,
                          size: 14,
                          color: colors.mutedDark,
                        ),
                        Text(
                          l10n.noteEditorBound(room),
                          style: NinjaText.helper.copyWith(
                            color: colors.mutedDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                NinjaInput.multiline(
                  controller: _controller,
                  autofocus: true,
                  minLines: 4,
                  maxLength: 1000,
                  placeholder: l10n.noteEditorPlaceholder,
                  textStyle: NinjaText.body.copyWith(
                    color: colors.ink,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const .symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.surfaceAlt,
                    borderRadius: .circular(NinjaRadius.card),
                  ),
                  child: SettingsToggleRow(
                    label: l10n.noteShareWithGroup,
                    sub: shareSub,
                    lineIcon: AppLineIcon.people,
                    value: _shared,
                    onChanged: (_) => _toggleShared(),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  spacing: 4,
                  children: [
                    _NoteToolButton(icon: .bolt, onTap: () => _insert('#')),
                    _NoteToolButton(icon: .check, onTap: () => _insert('\n☐ ')),
                    const Spacer(),
                    if (_savedShown)
                      Text(
                        l10n.noteSavedIndicator,
                        style: NinjaText.helper.copyWith(
                          color: colors.muted,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
