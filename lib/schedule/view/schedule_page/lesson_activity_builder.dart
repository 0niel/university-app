import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_dates.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets/lesson_note_sheet.dart';
import 'package:schedule_repository/schedule_repository.dart';

class LessonActivityBuilder extends StatefulWidget {
  const LessonActivityBuilder({
    required this.lesson,
    required this.day,
    required this.builder,
    super.key,
  });

  final LessonSchedulePart lesson;
  final DateTime day;
  final Widget Function(BuildContext, List<Widget>) builder;

  @override
  State<LessonActivityBuilder> createState() => _LessonActivityBuilderState();
}

class _LessonActivityBuilderState extends State<LessonActivityBuilder> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant LessonActivityBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lesson != widget.lesson ||
        !isSameDate(oldWidget.day, widget.day)) {
      _load();
    }
  }

  void _load() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(
        context.read<LessonReactionsCubit?>()?.ensureSummary(
          subjectName: widget.lesson.subject,
          lessonDate: dateOnly(widget.day),
          lessonBells: widget.lesson.lessonBells,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final comments = context.read<LessonCommentsCubit?>();
    final reactions = context.read<LessonReactionsCubit?>();
    final slotKey = ValueKey((
      widget.lesson.subject,
      dateOnly(widget.day),
      widget.lesson.lessonBells,
    ));
    Widget withReaction(LessonComment? note) => reactions == null
        ? _build(context, note, null)
        : BlocSelector<
            LessonReactionsCubit,
            LessonReactionsState,
            LessonReactionSummary?
          >(
            key: slotKey,
            bloc: reactions,
            selector: (state) => state.summaries
                .where(
                  (summary) =>
                      summary.subjectName == widget.lesson.subject &&
                      isSameDate(summary.lessonDate, widget.day) &&
                      summary.lessonBells == widget.lesson.lessonBells,
                )
                .firstOrNull,
            builder: (context, summary) => _build(context, note, summary),
          );
    return comments == null
        ? withReaction(null)
        : BlocSelector<
            LessonCommentsCubit,
            LessonCommentsState,
            LessonComment?
          >(
            key: slotKey,
            bloc: comments,
            selector: (state) => state.comments
                .where(
                  (note) =>
                      note.subjectName == widget.lesson.subject &&
                      isSameDate(note.lessonDate, widget.day) &&
                      note.lessonBells == widget.lesson.lessonBells &&
                      note.text.trim().isNotEmpty,
                )
                .firstOrNull,
            builder: (context, note) => withReaction(note),
          );
  }

  Widget _build(
    BuildContext context,
    LessonComment? note,
    LessonReactionSummary? summary,
  ) {
    final counts = summary?.reactionCounts;
    final entries =
        (counts?.entries.toList() ?? <MapEntry<ReactionType, int>>[])
          ..sort((a, b) {
            if (a.key == summary?.userReaction) return -1;
            if (b.key == summary?.userReaction) return 1;
            final count = b.value.compareTo(a.value);
            return count != 0 ? count : a.key.index.compareTo(b.key.index);
          });
    return widget.builder(context, [
      if (note != null)
        _marker(
          key: const ValueKey('lesson-note-marker'),
          label: context.l10n.noteEditorTitle,
          badge: const AppBadge(label: '1', icon: AppLineIcon.clipboard),
          onTap: () => showLessonNoteSheet(
            context,
            lesson: widget.lesson,
            day: widget.day,
          ),
        ),
      if (entries.isNotEmpty)
        _marker(
          key: const ValueKey('lesson-reactions-marker'),
          label: '${context.l10n.reactionSheetTitle}: ${counts!.total}',
          selected: summary?.userReaction != null,
          badge: AppBadge(
            label:
                '${entries.take(2).map((entry) => entry.key.emoji).join()} '
                '${counts.total > 999 ? '999+' : counts.total}',
            tone: summary?.userReaction != null
                ? AppBadgeTone.lecture
                : AppBadgeTone.neutral,
          ),
          onTap: () => ScheduleDetailsRoute(
            $extra: (widget.lesson, widget.day),
          ).push<void>(context),
        ),
    ]);
  }

  Widget _marker({
    required Key key,
    required String label,
    required Widget badge,
    required VoidCallback onTap,
    bool selected = false,
  }) => Tooltip(
    message: label,
    child: Semantics(
      selected: selected,
      child: AppPressable(
        key: key,
        semanticsLabel: label,
        semanticsButton: true,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44, minWidth: 44),
          child: Center(widthFactor: 1, heightFactor: 1, child: badge),
        ),
      ),
    ),
  );
}
