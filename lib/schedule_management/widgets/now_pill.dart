part of 'primary_schedule_card.dart';

class _NowPill extends StatelessWidget {
  const _NowPill({required this.status});

  final ScheduleLiveStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.ninja;
    final ongoing = status.ongoing;
    final next = status.next;
    final String headline;
    final String? meta;
    if (ongoing != null) {
      final lesson = ongoing.lesson;
      headline = l10n.scheduleHubNowSubject(lesson.subject);
      meta = [
        ?_room(lesson),
        l10n.scheduleHubLessonUntil(lesson.lessonBells.endTime.toString()),
        l10n.scheduleHubRemaining(ongoing.minutesLeft),
      ].join(' · ');
    } else if (next != null) {
      headline = l10n.scheduleHubNextSubject(next.subject);
      meta = [
        ?_room(next),
        l10n.scheduleHubNextAt(next.lessonBells.startTime.toString()),
      ].join(' · ');
    } else {
      headline = l10n.scheduleHubNoLessonsToday;
      meta = null;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colors.onAccentSoft.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(NinjaRadius.control),
      ),
      child: Row(
        spacing: 8,
        children: [
          if (ongoing != null) ...[
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.onAccentSoft,
                shape: BoxShape.circle,
              ),
              child: const SizedBox.square(dimension: 8),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              spacing: 2,
              children: [
                Text(
                  headline,
                  maxLines: 2,
                  overflow: .ellipsis,
                  style: NinjaText.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.onAccentSoft,
                  ),
                ),
                if (meta != null)
                  Text(
                    meta,
                    maxLines: 2,
                    overflow: .ellipsis,
                    style: NinjaText.tabular(
                      NinjaText.subtext.copyWith(
                        color: colors.onAccentSoftMuted,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          AppLineIconWidget(
            AppLineIcon.chevronR,
            size: 16,
            color: colors.onAccentSoftMuted,
          ),
        ],
      ),
    );
  }

  String? _room(LessonSchedulePart lesson) =>
      lesson.classrooms.firstOrNull?.name;
}
