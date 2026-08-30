part of '../schedule_page.dart';

class _TimelineLessonCard extends StatelessWidget {
  const _TimelineLessonCard({
    required this.lesson,
    required this.day,
    required this.onTap,
    required this.onActions,
    this.isNext = false,
    this.minutesToStart,
  });

  final LessonSchedulePart lesson;
  final DateTime day;
  final VoidCallback onTap;
  final VoidCallback onActions;
  final bool isNext;
  final int? minutesToStart;

  LessonComment? _commentFor(BuildContext context) {
    final comments = context.watch<LessonCommentsCubit>().state.comments;
    return comments.firstWhereOrNull(
      (comment) =>
          comment.lessonBells == lesson.lessonBells &&
          lesson.dates.any((date) => isSameDate(date, day)),
    );
  }

  LessonReactionSummary? _reactionsFor(BuildContext context) {
    final summaries = context.watch<LessonReactionsCubit>().state.summaries;
    return summaries.firstWhereOrNull(
      (summary) =>
          summary.subjectName == lesson.subject &&
          summary.lessonBells == lesson.lessonBells &&
          lesson.dates.any((date) => isSameDate(date, summary.lessonDate)),
    );
  }

  ScheduleChange? _changeFor(BuildContext context) {
    final changes = context.watch<ScheduleChangesCubit>().state.changes;
    return changes.firstWhereOrNull(
      (change) =>
          change.subject == lesson.subject &&
          isSameDate(change.lessonDate, day) &&
          change.kind != .add,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final status = _lessonStatus(lesson, day);
    final live = status.live;
    final highlighted = live || isNext;
    final baseAccent = colors.subjectBaseColor(lesson.subject);
    final background = highlighted
        ? Color.alphaBlend(
            baseAccent.withValues(alpha: colors.isDark ? .16 : .1),
            colors.surface,
          )
        : colors.surface;
    final accent = colors.accentOn(baseAccent, background);
    final foreground = colors.ink;
    final muted = colors.mutedDark;
    final comment = _commentFor(context);
    final reactions = live ? null : _reactionsFor(context);
    final change = _changeFor(context);
    final changeInfo = change == null
        ? null
        : _changeChip(l10n, colors, change);
    final prepText = prepHint(l10n, lesson);
    final showPrep =
        prepText != null && !status.past && !live && change == null;
    final classmates = live || isNext
        ? context.watch<ClassmatesCubit>().state.firstNames
        : const <String>[];
    final room = singleClassroomText(l10n, lesson);
    final teachers = lesson.teachers.map((teacher) => teacher.name).join(', ');
    final groups = lessonGroupsLabel(
      lesson,
      context.read<ScheduleBloc>().state.selectedSchedule,
    );
    final type = LessonCard.getLessonTypeName(l10n, lesson.lessonType);
    final statusText = live
        ? '${l10n.liveNow} · ${l10n.minutesLeft(status.minutesLeft)}'
        : isNext && minutesToStart != null
        ? inMinutesText(l10n, minutesToStart ?? 0)
        : null;
    final start = lesson.lessonBells.startTime.toString();
    final end = lesson.lessonBells.endTime.toString();
    final largeText = MediaQuery.textScalerOf(context).scale(1) >= 1.5;
    final showProgress = live && status.progress != null;
    final key = '${_dayKey(day)}-${minutesOfDay(lesson.lessonBells.startTime)}';

    Widget card = Container(
      key: ValueKey('schedule-lesson-card-$key'),
      clipBehavior: .antiAlias,
      decoration: BoxDecoration(
        color: background,
        borderRadius: .circular(NinjaRadius.card),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 14,
            bottom: 14,
            child: Container(
              key: ValueKey('schedule-lesson-accent-$key'),
              width: 4,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
            ),
          ),
          Padding(
            padding: const .fromLTRB(18, 14, 16, 15),
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                if (largeText) ...[
                  _LessonTimeRange(start: start, end: end, color: foreground),
                  const SizedBox(height: 5),
                  Align(
                    alignment: .centerRight,
                    child: Text(
                      key: ValueKey('schedule-lesson-type-$key'),
                      type.toUpperCase(),
                      maxLines: 2,
                      overflow: .ellipsis,
                      textAlign: .right,
                      style: NinjaText.microLabel.copyWith(color: accent),
                    ),
                  ),
                ] else
                  Row(
                    crossAxisAlignment: .start,
                    children: [
                      Expanded(
                        child: _LessonTimeRange(
                          start: start,
                          end: end,
                          color: foreground,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Align(
                          alignment: .topRight,
                          child: Text(
                            key: ValueKey('schedule-lesson-type-$key'),
                            type.toUpperCase(),
                            maxLines: 2,
                            overflow: .ellipsis,
                            textAlign: .right,
                            style: NinjaText.microLabel.copyWith(color: accent),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (statusText != null) ...[
                  const SizedBox(height: 7),
                  Text(
                    statusText,
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: NinjaText.microLabel.copyWith(
                      color: live ? colors.brandInk : accent,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  lesson.subject,
                  maxLines: 3,
                  overflow: .ellipsis,
                  style: NinjaText.dialogTitle.copyWith(color: foreground),
                ),
                const SizedBox(height: 9),
                Text(
                  room,
                  maxLines: 2,
                  overflow: .ellipsis,
                  style: NinjaText.body.copyWith(color: foreground),
                ),
                if (teachers.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    teachers,
                    maxLines: 2,
                    overflow: .ellipsis,
                    style: NinjaText.subtext.copyWith(color: muted),
                  ),
                ],
                if (groups != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    groups,
                    maxLines: 2,
                    overflow: .ellipsis,
                    style: NinjaText.subtext.copyWith(color: muted),
                  ),
                ],
                if (changeInfo != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    changeInfo.label,
                    style: NinjaText.helper.copyWith(color: changeInfo.color),
                  ),
                ],
                if (showPrep)
                  _LessonExtraRow(text: prepText, foreground: muted),
                if (comment != null && comment.text.isNotEmpty)
                  _NoteRow(
                    text: comment.text,
                    dimmed: status.past,
                    foreground: muted,
                  ),
                if (reactions != null && reactions.totalReactions > 0)
                  _InlineReactions(
                    summary: reactions,
                    dimmed: status.past,
                    foreground: muted,
                  ),
                if (classmates.isNotEmpty)
                  _FriendsOnClass(names: classmates, foreground: muted),
                if (live) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      NinjaButton.secondary(
                        label: l10n.classActionRoute,
                        size: .small,
                        onPressed: () => context.go('/services/map'),
                      ),
                      NinjaButton.secondary(
                        label: l10n.classActionNote,
                        size: .small,
                        onPressed: onTap,
                      ),
                    ],
                  ),
                ],
                if (showProgress) ...[
                  const SizedBox(height: 12),
                  _LessonProgressBar(value: status.progress ?? 0),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    if (status.past) card = Opacity(opacity: .52, child: card);
    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        0,
        NinjaMetrics.screenPadding,
        8,
      ),
      child: Semantics(
        button: true,
        label: '${lesson.subject}, $start–$end, $type, $room, $teachers',
        child: AppPressable(
          onTap: onTap,
          onLongPress: onActions,
          child: card,
        ),
      ),
    );
  }
}

class _LessonTimeRange extends StatelessWidget {
  const _LessonTimeRange({
    required this.start,
    required this.end,
    required this.color,
  });

  final String start;
  final String end;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: start,
            style: NinjaText.headline.copyWith(color: color),
          ),
          TextSpan(
            text: '  —  $end',
            style: NinjaText.subtext.copyWith(color: context.ninja.mutedDark),
          ),
        ],
      ),
      maxLines: 1,
      overflow: .ellipsis,
      style: NinjaText.tabular(NinjaText.headline),
    );
  }
}
