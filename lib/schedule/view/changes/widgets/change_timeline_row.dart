part of '../changes_page.dart';

class _ChangeTimelineRow extends StatelessWidget {
  const _ChangeTimelineRow({required this.change, required this.last});

  final ScheduleChange change;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final style = _styleFor(context, change);
    final locale = Localizations.localeOf(context).toString();

    return Padding(
      padding: .only(bottom: last ? 4 : 10),
      child: NinjaScheduleSurface(
        child: Row(
          crossAxisAlignment: .start,
          spacing: 12,
          children: [
            Container(
              width: NinjaMetrics.minTouchTarget,
              height: NinjaMetrics.minTouchTarget,
              decoration: BoxDecoration(
                color: style.color.withValues(alpha: .12),
                shape: .circle,
              ),
              child: Center(
                child: AppLineIconWidget(
                  style.icon,
                  size: 19,
                  color: style.color,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    style.title,
                    style: NinjaText.headline.copyWith(color: colors.ink),
                  ),
                  if (style.description.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      style.description,
                      style: NinjaText.subtext.copyWith(
                        color: colors.muted,
                        height: 1.4,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: .center,
                    children: [
                      Container(
                        padding: const .symmetric(
                          horizontal: 9,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: colors.surfaceAlt,
                          borderRadius: .circular(NinjaRadius.pill),
                        ),
                        child: Text(
                          _dayChip(context, change.lessonDate, locale),
                          style: NinjaText.helper.copyWith(
                            color: colors.mutedDark,
                          ),
                        ),
                      ),
                      Text(
                        _relativeTime(context, change.createdAt),
                        style: NinjaText.helper.copyWith(color: colors.muted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ({AppLineIcon icon, Color color, String title, String description}) _styleFor(
    BuildContext context,
    ScheduleChange scheduleChange,
  ) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final oldValue = scheduleChange.oldValue;
    final newValue = scheduleChange.newValue;
    final newStart = newValue.start;
    return switch (scheduleChange.kind) {
      .move => (
        icon: AppLineIcon.clock,
        color: colors.brand,
        title: l10n.changeMovedTitle(scheduleChange.subject),
        description: l10n.changeMovedDescription(
          oldValue.start ?? '—',
          newValue.start ?? '—',
        ),
      ),
      .cancel => (
        icon: AppLineIcon.close,
        color: colors.scarlet,
        title: l10n.changeCancelledTitle(scheduleChange.subject),
        description: switch (oldValue.start) {
          final start? => l10n.changeCancelledDescription(start),
          _ => '',
        },
      ),
      .add => (
        icon: AppLineIcon.plus,
        color: colors.brand,
        title: l10n.changeAddedTitle(scheduleChange.subject),
        description: [
          if (newValue.teachers.isNotEmpty) newValue.teachers.join(', '),
          if (newValue.rooms.isNotEmpty) newValue.rooms.join(', '),
          ?newStart,
        ].join(' · '),
      ),
      .teacher => (
        icon: AppLineIcon.people,
        color: colors.brand,
        title: l10n.changeTeacherTitle,
        description:
            '${scheduleChange.subject}: ${oldValue.teachers.join(', ')} → '
            '${newValue.teachers.join(', ')}',
      ),
      .room => (
        icon: AppLineIcon.pin,
        color: colors.brand,
        title: l10n.changeRoomTitle,
        description:
            '${scheduleChange.subject}: ${oldValue.rooms.join(', ')} → '
            '${newValue.rooms.join(', ')}',
      ),
    };
  }

  String _dayChip(BuildContext context, DateTime date, String locale) {
    final today = DateTime.now();
    final dateOnly = DateTime(date.year, date.month, date.day);
    final todayOnly = DateTime(today.year, today.month, today.day);
    final delta = dateOnly.difference(todayOnly).inDays;
    if (delta == 0) return context.l10n.todayLabel;
    if (delta == 1) return context.l10n.tomorrowLabel;
    return DateFormat('d MMMM', locale).format(date);
  }

  String _relativeTime(BuildContext context, DateTime time) {
    final l10n = context.l10n;
    final delta = DateTime.now().difference(time);
    if (delta.inMinutes < 60) return l10n.minutesAgo(delta.inMinutes);
    if (delta.inHours < 24) return l10n.hoursAgo(delta.inHours);
    if (delta.inDays == 1) return l10n.yesterdayLabel;
    return l10n.daysAgo(delta.inDays);
  }
}
