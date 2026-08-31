part of '../schedule_page.dart';

String _scheduleDayLabel(BuildContext context, RussianDayInfo info) {
  final l10n = context.l10n;
  return switch (info.kind) {
    .workday => '',
    .weekend => l10n.weekendShort,
    .transferredDayOff => l10n.scheduleTransferredDayOff,
    .transferredWorkday => l10n.scheduleTransferredWorkday,
    .publicHoliday => switch (info.holiday) {
      .newYearHolidays => l10n.newYearHolidays,
      .orthodoxChristmas => l10n.orthodoxChristmas,
      .defenderOfFatherlandDay => l10n.defenderOfFatherlandDay,
      .internationalWomensDay => l10n.internationalWomensDay,
      .springAndLaborDay => l10n.springAndLaborDay,
      .victoryDay => l10n.victoryDay,
      .russiaDay => l10n.russiaDay,
      .nationalUnityDay => l10n.nationalUnityDay,
      null => l10n.holiday,
    },
  };
}

Color _scheduleDayAccent(NinjaColors colors, RussianDayInfo info) {
  return switch (info.kind) {
    .publicHoliday || .transferredDayOff => colors.scarlet,
    .weekend || .transferredWorkday => colors.amberInk,
    .workday => colors.ink,
  };
}

Color _scheduleDaySurface(NinjaColors colors, RussianDayInfo info) {
  return switch (info.kind) {
    .publicHoliday || .transferredDayOff => colors.dangerTint,
    .weekend || .transferredWorkday => colors.warnTint,
    .workday => colors.surface,
  };
}

class _ScheduleDayOffPill extends StatelessWidget {
  const _ScheduleDayOffPill({required this.info, super.key});

  final RussianDayInfo info;

  @override
  Widget build(BuildContext context) {
    if (!info.isSpecial) return const SizedBox.shrink();
    final colors = context.ninja;
    final accent = _scheduleDayAccent(colors, info);
    return Container(
      padding: const .symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: colors.isDark ? .16 : .1),
        borderRadius: .circular(NinjaRadius.pill),
      ),
      child: Text(
        _scheduleDayLabel(context, info),
        maxLines: 1,
        overflow: .ellipsis,
        style: NinjaText.badge.copyWith(color: accent),
      ),
    );
  }
}

class _ScheduleTransferCoveragePill extends StatelessWidget {
  const _ScheduleTransferCoveragePill({required this.year});

  final int year;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final label = context.l10n.scheduleTransferCalendarPending(year);
    return Container(
      padding: const .symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors.warnTint,
        borderRadius: .circular(NinjaRadius.pill),
      ),
      child: Text(
        label,
        maxLines: 2,
        overflow: .ellipsis,
        style: NinjaText.badge.copyWith(color: colors.amberInk),
      ),
    );
  }
}
