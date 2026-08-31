part of '../schedule_page.dart';

class _ScheduleNextLessonCard extends StatelessWidget {
  const _ScheduleNextLessonCard({
    required this.day,
    required this.lesson,
    required this.onTap,
  });

  final DateTime day;
  final LessonSchedulePart lesson;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final locale = Localizations.localeOf(context).toString();
    final date = capitalizeFirst(
      DateFormat('EEEE, d MMMM', locale).format(day),
    );
    final room = lesson.classrooms.isEmpty
        ? '—'
        : lesson.classrooms.map((item) => item.name).join(', ');
    final baseAccent = colors.subjectBaseColor(lesson.subject);
    final accent = colors.subjectColor(lesson.subject);
    final badgeFill = Color.alphaBlend(
      baseAccent.withValues(alpha: colors.isDark ? .2 : .14),
      colors.surface,
    );
    final badgeAccent = colors.accentOn(baseAccent, badgeFill);
    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        10,
        NinjaMetrics.screenPadding,
        0,
      ),
      child: Semantics(
        button: true,
        label: '$date, ${lesson.subject}, $room',
        child: NinjaCard(
          onTap: onTap,
          padding: const .all(12),
          child: Row(
            children: [
              ExcludeSemantics(
                child: Container(
                  width: NinjaMetrics.minTouchTarget,
                  height: NinjaMetrics.minTouchTarget,
                  alignment: .center,
                  decoration: BoxDecoration(
                    color: badgeFill,
                    shape: .circle,
                  ),
                  child: AppLineIconWidget(
                    LessonCard.getIconByType(lesson.lessonType),
                    size: 21,
                    color: badgeAccent,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      date,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: NinjaText.microLabel.copyWith(color: accent),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      lesson.subject,
                      maxLines: 2,
                      overflow: .ellipsis,
                      style: NinjaText.body.copyWith(
                        color: colors.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${timeRangeText(lesson)} · $room',
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: NinjaText.helper.copyWith(color: colors.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AppLineIconWidget(.arrowRight, size: 18, color: colors.ink),
            ],
          ),
        ),
      ),
    );
  }
}
