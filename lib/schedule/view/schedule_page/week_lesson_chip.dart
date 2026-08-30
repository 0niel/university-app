part of '../schedule_page.dart';

class _WeekLessonChip extends StatelessWidget {
  const _WeekLessonChip({
    required this.lesson,
    required this.day,
    required this.expanded,
    required this.onTap,
    required this.onLongPress,
    super.key,
  });

  final LessonSchedulePart lesson;
  final DateTime day;
  final bool expanded;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final lessonAccent = colors.subjectColor(lesson.subject);
    final status = _lessonStatus(lesson, day);
    final secondary = colors.mutedDark;
    final tone = status.live ? colors.brand : lessonAccent;
    final details = lessonMetaText(context.l10n, lesson);
    final semantics = [
      timeRangeText(lesson),
      lesson.subject,
      details,
      context.l10n.scheduleWeekHoldLesson,
    ].join(', ');

    return Padding(
      padding: const .only(bottom: 8),
      child: Opacity(
        opacity: status.past ? .55 : 1,
        child: AppPressable(
          onTap: onTap,
          onLongPress: onLongPress,
          semanticsLabel: semantics,
          semanticsToggled: expanded,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: NinjaMetrics.minTouchTarget,
            ),
            child: AnimatedContainer(
              key: ValueKey(
                'schedule-week-lesson-${_dayKey(day)}-'
                '${lesson.uid ?? lesson.subject}',
              ),
              duration: NinjaMotion.of(context),
              curve: NinjaMotion.enter,
              padding: EdgeInsets.fromLTRB(8, 8, 8, expanded ? 10 : 8),
              decoration: BoxDecoration(
                color: expanded ? colors.surfaceAlt : Colors.transparent,
                borderRadius: .circular(NinjaRadius.control),
              ),
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  Row(
                    crossAxisAlignment: .start,
                    children: [
                      SizedBox(
                        width: 70,
                        child: Text(
                          timeRangeText(lesson),
                          style: NinjaText.tabular(
                            NinjaText.helper.copyWith(color: secondary),
                          ),
                        ),
                      ),
                      Container(
                        width: 8,
                        height: 8,
                        margin: const .only(top: 3),
                        decoration: BoxDecoration(color: tone, shape: .circle),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          lesson.subject,
                          maxLines: expanded ? null : 2,
                          overflow: expanded ? null : .ellipsis,
                          style: NinjaText.subtext.copyWith(color: colors.ink),
                        ),
                      ),
                      const SizedBox(width: 5),
                      AnimatedRotation(
                        turns: expanded ? .5 : 0,
                        duration: NinjaMotion.of(context),
                        curve: NinjaMotion.enter,
                        child: AppLineIconWidget(
                          AppLineIcon.chevronD,
                          size: 14,
                          color: expanded ? tone : colors.chevron,
                        ),
                      ),
                    ],
                  ),
                  AnimatedSize(
                    duration: NinjaMotion.of(context, NinjaMotion.slow),
                    curve: NinjaMotion.emphasized,
                    alignment: Alignment.topCenter,
                    child: expanded
                        ? Padding(
                            key: ValueKey(
                              'schedule-week-lesson-details-${_dayKey(day)}-'
                              '${lesson.uid ?? lesson.subject}',
                            ),
                            padding: const .only(top: 8, left: 87),
                            child: Text(
                              details,
                              style: NinjaText.helper.copyWith(
                                color: colors.mutedDark,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
