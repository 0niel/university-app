part of '../schedule_page.dart';

class _WeekDayColumn extends StatefulWidget {
  const _WeekDayColumn({
    required this.day,
    required this.today,
    required this.lessons,
    required this.activities,
    required this.onTap,
    super.key,
  });

  final DateTime day;
  final bool today;
  final List<LessonSchedulePart> lessons;
  final List<UserActivity> activities;
  final VoidCallback onTap;

  @override
  State<_WeekDayColumn> createState() => _WeekDayColumnState();
}

class _WeekDayColumnState extends State<_WeekDayColumn> {
  String? _expandedLesson;
  bool _showAll = false;

  void _toggleLesson(String key) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _expandedLesson = _expandedLesson == key ? null : key);
  }

  void _toggleAll() {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _showAll = !_showAll;
      if (!_showAll) _expandedLesson = null;
    });
  }

  String _lessonKey(LessonSchedulePart lesson) {
    return lesson.uid ??
        '${_dayKey(widget.day)}-'
            '${minutesOfDay(lesson.lessonBells.startTime)}-'
            '${minutesOfDay(lesson.lessonBells.endTime)}-'
            '${lesson.lessonType.name}-${lesson.subject}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final locale = Localizations.localeOf(context).toString();
    final weekday = capitalizeFirst(
      DateFormat('EEEE', locale).format(widget.day),
    );
    final date = DateFormat('d MMMM', locale).format(widget.day);
    final largeText = MediaQuery.textScalerOf(context).scale(1) >= 1.5;
    final dayInfo = RussianWorkCalendar.dayInfo(widget.day);
    final total = widget.lessons.length + widget.activities.length;
    final entries = <({int minute, Widget child})>[
      for (final lesson in widget.lessons)
        (
          minute: minutesOfDay(lesson.lessonBells.startTime),
          child: _WeekLessonChip(
            key: ValueKey(_lessonKey(lesson)),
            lesson: lesson,
            day: widget.day,
            expanded: _expandedLesson == _lessonKey(lesson),
            onTap: widget.onTap,
            onLongPress: () => _toggleLesson(_lessonKey(lesson)),
          ),
        ),
      for (final activity in widget.activities)
        (
          minute: activity.startsAt.hour * 60 + activity.startsAt.minute,
          child: _WeekActivityChip(activity: activity),
        ),
    ]..sort((a, b) => a.minute.compareTo(b.minute));
    final summary = [
      context.l10n.lessonsCount(widget.lessons.length),
      if (widget.activities.isNotEmpty)
        context.l10n.eventsCountSuffix(widget.activities.length),
    ].join(' · ');
    final semantics = [
      weekday,
      date,
      summary,
      if (dayInfo.isSpecial) _scheduleDayLabel(context, dayInfo),
    ].join(', ');
    final visibleEntries = _showAll ? entries : entries.take(3).toList();

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Container(
        key: ValueKey('schedule-week-day-card-${_dayKey(widget.day)}'),
        padding: const .all(16),
        decoration: BoxDecoration(
          color: widget.today
              ? colors.brandTint
              : dayInfo.isSpecial
              ? _scheduleDaySurface(colors, dayInfo)
              : colors.surface,
          borderRadius: .circular(NinjaRadius.card),
        ),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            AppPressable(
              onTap: widget.onTap,
              semanticsLabel: semantics,
              child: Row(
                crossAxisAlignment: .start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                weekday,
                                maxLines: 1,
                                overflow: .ellipsis,
                                style: NinjaText.headline.copyWith(
                                  color: colors.ink,
                                ),
                              ),
                            ),
                            if (widget.today) ...[
                              const SizedBox(width: 8),
                              const _WeekTodayPill(),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          crossAxisAlignment: .center,
                          children: [
                            Text(
                              date,
                              style: NinjaText.subtext.copyWith(
                                color: colors.mutedDark,
                              ),
                            ),
                            if (dayInfo.isSpecial)
                              _ScheduleDayOffPill(
                                key: ValueKey(
                                  'schedule-week-day-off-'
                                  '${_dayKey(widget.day)}',
                                ),
                                info: dayInfo,
                              ),
                          ],
                        ),
                        if (largeText && entries.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            summary,
                            style: NinjaText.buttonSmall.copyWith(
                              color: widget.today
                                  ? colors.brandInk
                                  : colors.mutedDark,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (!largeText && entries.isNotEmpty) ...[
                    Flexible(
                      child: Text(
                        summary,
                        maxLines: 2,
                        textAlign: .end,
                        overflow: .ellipsis,
                        style: NinjaText.buttonSmall.copyWith(
                          color: widget.today
                              ? colors.brandInk
                              : colors.mutedDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  AppLineIconWidget(
                    AppLineIcon.chevronR,
                    size: 18,
                    color: widget.today ? colors.brandInk : colors.chevron,
                  ),
                ],
              ),
            ),
            if (entries.isEmpty)
              ConstrainedBox(
                key: ValueKey('schedule-week-empty-${_dayKey(widget.day)}'),
                constraints: const BoxConstraints(minHeight: 58),
                child: Center(
                  child: Text(
                    context.l10n.noLessonsShort,
                    textAlign: .center,
                    style: NinjaText.button.copyWith(
                      color: dayInfo.isSpecial
                          ? _scheduleDayAccent(colors, dayInfo)
                          : colors.mutedDark,
                    ),
                  ),
                ),
              )
            else ...[
              const SizedBox(height: 14),
              AnimatedSize(
                duration: NinjaMotion.of(context, NinjaMotion.slow),
                curve: NinjaMotion.emphasized,
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    for (final entry in visibleEntries) entry.child,
                  ],
                ),
              ),
              if (total > 3)
                AppPressable(
                  onTap: _toggleAll,
                  onLongPress: _toggleAll,
                  semanticsLabel: _showAll
                      ? context.l10n.scheduleWeekHoldToCollapse
                      : context.l10n.scheduleWeekHoldToExpand(total - 3),
                  semanticsToggled: _showAll,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: NinjaMetrics.minTouchTarget,
                    ),
                    child: Padding(
                      padding: const .only(top: 4, bottom: 2),
                      child: Row(
                        mainAxisAlignment: .center,
                        children: [
                          Flexible(
                            child: Text(
                              _showAll
                                  ? context.l10n.scheduleWeekHoldToCollapse
                                  : context.l10n.scheduleWeekHoldToExpand(
                                      total - 3,
                                    ),
                              maxLines: 2,
                              textAlign: .center,
                              overflow: .ellipsis,
                              style: NinjaText.helper.copyWith(
                                color: widget.today
                                    ? colors.brandInk
                                    : colors.mutedDark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          AnimatedRotation(
                            turns: _showAll ? .5 : 0,
                            duration: NinjaMotion.of(context),
                            curve: NinjaMotion.enter,
                            child: AppLineIconWidget(
                              AppLineIcon.chevronD,
                              size: 14,
                              color: widget.today
                                  ? colors.brandInk
                                  : colors.chevron,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
