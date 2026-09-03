import 'package:academic_calendar/academic_calendar.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

String scheduleDayLabel(BuildContext context, DateTime day) {
  final info = RussianWorkCalendar.dayInfo(day);
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

bool scheduleSpecialDay(DateTime day) =>
    switch (RussianWorkCalendar.dayInfo(day).kind) {
      .publicHoliday || .transferredDayOff || .transferredWorkday => true,
      _ => false,
    };

class ScheduleCalendarNotice extends StatelessWidget {
  const ScheduleCalendarNotice({required this.day, super.key});
  final DateTime day;

  @override
  Widget build(BuildContext context) {
    final info = RussianWorkCalendar.dayInfo(day);
    final messages = [
      if (scheduleSpecialDay(day)) scheduleDayLabel(context, day),
      if (!info.transferCalendarKnown)
        context.l10n.scheduleTransferCalendarPending(day.year),
    ];
    if (messages.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppBanner(message: messages.join(' · '), tone: AppBannerTone.warn),
    );
  }
}
