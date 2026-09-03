import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_details_page.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_text.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_dates.dart';
import 'package:schedule_repository/schedule_repository.dart';

Future<void> showLessonNoteSheet(
  BuildContext context, {
  required LessonSchedulePart lesson,
  required DateTime day,
}) {
  final comments = context.read<LessonCommentsCubit>();
  final existing = comments.state.comments
      .where(
        (c) =>
            c.subjectName == lesson.subject &&
            isSameDate(c.lessonDate, day) &&
            c.lessonBells == lesson.lessonBells,
      )
      .firstOrNull;
  return showAppSheet<void>(
    context,
    title: context.l10n.noteEditorTitle,
    subtitle: context.l10n.scheduleNoteSubtitle,
    child: _NoteEditor(
      lesson: lesson,
      day: day,
      comments: comments,
      existing: existing,
      campus: context.read<CampusRepository>(),
      repository: context.read<ScheduleRepository>(),
    ),
  );
}

class _NoteEditor extends StatefulWidget {
  const _NoteEditor({
    required this.lesson,
    required this.day,
    required this.comments,
    required this.campus,
    required this.repository,
    this.existing,
  });
  final LessonSchedulePart lesson;
  final DateTime day;
  final LessonCommentsCubit comments;
  final LessonComment? existing;
  final CampusRepository campus;
  final ScheduleRepository repository;
  @override
  State<_NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<_NoteEditor> {
  static const _defaultMaxLength = 1000;
  late final _text = _NoteTextController(text: widget.existing?.text ?? '');
  late final int _maxLength = math.max(
    _defaultMaxLength,
    widget.existing?.text.characters.length ?? 0,
  );
  late bool _shared = widget.existing?.isSharedWithGroup ?? false;
  bool _saving = false;
  String? _error;
  String? _createdNoteId;
  late String? _publishedText = widget.existing?.isSharedWithGroup == true
      ? widget.existing!.text.trim()
      : null;

  @override
  void initState() {
    super.initState();
    _text.addListener(_autosave);
  }

  void _autosave() {
    if (widget.comments.isClosed) return;
    _persist(shared: _publishedText == _text.text.trim());
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _persist({required bool shared}) {
    if (widget.comments.isClosed) return;
    widget.comments.setLessonComment(
      LessonComment(
        subjectName: widget.lesson.subject,
        lessonDate: widget.existing?.lessonDate ?? dateOnly(widget.day),
        lessonBells: widget.lesson.lessonBells,
        text: _text.text.trim(),
        isSharedWithGroup: shared,
      ),
    );
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      if (_shared &&
          _text.text.trim().isNotEmpty &&
          _text.text.trim() != _publishedText) {
        final id = _createdNoteId ??= await widget.campus.createGroupNote(
          widget.lesson.subject,
        );
        await widget.campus.saveGroupNote(
          id: id,
          title: widget.lesson.subject,
          content: _text.text.trim(),
          expectedRevision: 0,
        );
        _publishedText = _text.text.trim();
      }
      _persist(shared: _shared);
      if (!mounted) return;
      ToastManager.showSuccess(
        context,
        message: context.l10n.scheduleNoteSaved,
      );
      Navigator.of(context).pop();
    } on Exception {
      _persist(shared: false);
      if (mounted) setState(() => _error = context.l10n.scheduleActionFailed);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _insert(String snippet) {
    final selection = _text.selection;
    final start = selection.start < 0 ? _text.text.length : selection.start;
    final end = selection.end < 0 ? start : selection.end;
    final result = _text.text.replaceRange(start, end, snippet);
    if (result.characters.length > _maxLength) return;
    _text.value = TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: start + snippet.length),
    );
  }

  Future<void> _materials() async {
    _autosave();
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => RepositoryProvider.value(
          value: widget.repository,
          child: LessonMaterialsPage(
            lesson: widget.lesson,
            selectedDate: widget.day,
            lessonNumber: lessonNumberOf(widget.lesson) ?? 1,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppInputField.multiline(
          controller: _text,
          placeholder: l10n.scheduleNotePlaceholder,
          autofocus: true,
          maxLength: _maxLength,
          minLines: 4,
          fillColor: context.colors.surface,
          enabled: !_saving,
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            AppButton.secondary(
              label: l10n.scheduleNoteAddFile,
              size: AppButtonSize.small,
              onPressed: _saving ? null : _materials,
            ),
            AppButton.secondary(
              label: l10n.scheduleNoteAddBoard,
              size: AppButtonSize.small,
              onPressed: _saving ? null : _materials,
            ),
            AppButton.secondary(
              key: const ValueKey('lesson-note-tag'),
              label: l10n.scheduleNoteTag,
              size: AppButtonSize.small,
              onPressed: _saving ? null : () => _insert('#'),
            ),
            AppButton.secondary(
              key: const ValueKey('lesson-note-checklist'),
              label: l10n.scheduleNoteChecklist,
              size: AppButtonSize.small,
              icon: const AppLineIconWidget(AppLineIcon.check),
              onPressed: _saving ? null : () => _insert('\n☐ '),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        AppListGroup(
          children: [
            AppListRow(
              title: l10n.noteShareWithGroup,
              subtitle: l10n.noteShareWithGroupGeneric,
              trailing: AppSwitch(
                value: _shared,
                semanticsLabel: l10n.noteShareWithGroup,
                onChanged: _saving || widget.existing?.isSharedWithGroup == true
                    ? null
                    : (value) => setState(() => _shared = value),
              ),
            ),
          ],
        ),
        if (_error != null) ...[
          const SizedBox(height: AppSpacing.md),
          AppBanner(message: _error!, tone: AppBannerTone.danger),
        ],
        const SizedBox(height: AppSpacing.sectionGap),
        AppButton.primary(
          label: l10n.save,
          expanded: true,
          size: AppButtonSize.large,
          loading: _saving,
          onPressed: _saving ? null : _save,
        ),
      ],
    );
  }
}

class _NoteTextController extends TextEditingController {
  _NoteTextController({super.text});

  static final _hashtagPattern = RegExp(r'#[\wА-Яа-яЁё]+', unicode: true);

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    required bool withComposing,
    TextStyle? style,
  }) {
    if (withComposing &&
        value.isComposingRangeValid &&
        !value.composing.isCollapsed) {
      return super.buildTextSpan(
        context: context,
        withComposing: withComposing,
        style: style,
      );
    }
    final spans = <TextSpan>[];
    var offset = 0;
    for (final match in _hashtagPattern.allMatches(text)) {
      if (match.start > offset) {
        spans.add(TextSpan(text: text.substring(offset, match.start)));
      }
      spans.add(
        TextSpan(
          text: match.group(0),
          style: TextStyle(
            color: context.colors.accent,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
      offset = match.end;
    }
    if (offset < text.length) spans.add(TextSpan(text: text.substring(offset)));
    return TextSpan(style: style, children: spans);
  }
}
