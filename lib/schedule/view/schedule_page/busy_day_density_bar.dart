part of '../schedule_page.dart';

class _BusyDayDensityBar extends StatelessWidget {
  const _BusyDayDensityBar({required this.lessons, required this.activities});

  final List<LessonSchedulePart> lessons;
  final List<UserActivity> activities;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final entries = <int>[
      for (final lesson in lessons) minutesOfDay(lesson.lessonBells.startTime),
      for (final activity in activities)
        activity.startsAt.hour * 60 + activity.startsAt.minute,
    ]..sort();
    final first = entries.firstOrNull;
    final last = entries.lastOrNull;
    if (first == null || last == null) return const SizedBox.shrink();

    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        12,
        NinjaMetrics.screenPadding,
        0,
      ),
      child: Container(
        constraints: const BoxConstraints(minHeight: 44),
        padding: const .symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: colors.warnTint,
          borderRadius: .circular(NinjaRadius.pill),
        ),
        child: Row(
          children: [
            AppLineIconWidget(
              AppLineIcon.bolt,
              size: 17,
              color: colors.amberInk,
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                context.l10n.activitiesCount(entries.length),
                style: NinjaText.body.copyWith(color: colors.ink),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${_hhmm(first)}–${_hhmm(last + 90)}',
              style: NinjaText.tabular(
                NinjaText.helper.copyWith(color: colors.mutedDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _hhmm(int minutes) {
    final clamped = math.min(minutes, 23 * 60 + 59);
    final hour = (clamped ~/ 60).toString().padLeft(2, '0');
    final minute = (clamped % 60).toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
