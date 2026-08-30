import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_text.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_dates.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets/widgets/schedule_sheet_widgets.dart';
import 'package:rtu_mirea_app/schedule_management/bloc/schedule_exporter_cubit.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'export_period.dart';

Future<void> showScheduleExportSheet(BuildContext context) {
  final l10n = context.l10n;
  final lessons =
      context
          .read<ScheduleBloc>()
          .state
          .selectedSchedule
          ?.schedule
          .whereType<LessonSchedulePart>()
          .toList() ??
      const <LessonSchedulePart>[];

  var period = _ExportPeriod.week;
  var destination = 0;
  var reminders = true;
  var autoUpdate = true;
  var includeRooms = true;

  return showAppSheet<void>(
    context,
    title: l10n.exportScheduleTitle,
    subtitle: l10n.exportScheduleSubtitle,
    backgroundColor: context.ninja.canvas,
    child: StatefulBuilder(
      builder: (context, setState) {
        final destinations = [
          (l10n.exportSystemCalendar, l10n.exportSystemCalendarSub),
          (l10n.exportGoogleCalendar, l10n.exportGoogleCalendarSub),
          (l10n.exportIcsFile, l10n.exportIcsFileSub),
          (l10n.exportPng, l10n.exportPngSub),
        ];
        return Padding(
          padding: const .fromLTRB(0, 4, 0, 24),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              NinjaSegmented<_ExportPeriod>(
                value: period,
                expanded: true,
                onChanged: (value) => setState(() => period = value),
                segments: [
                  NinjaSegment(value: .today, label: l10n.exportPeriodToday),
                  NinjaSegment(value: .week, label: l10n.exportPeriodWeek),
                  NinjaSegment(
                    value: .semester,
                    label: l10n.exportPeriodSemester,
                  ),
                ],
              ),
              ScheduleSheetSectionLabel(l10n.exportWhereSection),
              for (final (index, item) in destinations.indexed)
                ScheduleSheetRadioRow(
                  title: item.$1,
                  subtitle: item.$2,
                  selected: destination == index,
                  first: index == 0,
                  onTap: () => setState(() => destination = index),
                ),
              ScheduleSheetSectionLabel(l10n.exportOptionsSection),
              ScheduleSheetToggleRow(
                title: l10n.exportReminders,
                subtitle: l10n.exportRemindersSub,
                value: reminders,
                first: true,
                onChanged: (value) => setState(() => reminders = value),
              ),
              ScheduleSheetToggleRow(
                title: l10n.exportAutoUpdate,
                subtitle: l10n.exportAutoUpdateSub,
                value: autoUpdate,
                onChanged: (value) => setState(() => autoUpdate = value),
              ),
              ScheduleSheetToggleRow(
                title: l10n.exportIncludeRooms,
                value: includeRooms,
                onChanged: (value) => setState(() => includeRooms = value),
              ),
              const SizedBox(height: 22),
              NinjaButton.primary(
                label: switch (period) {
                  .today => l10n.exportActionToday,
                  .week => l10n.exportActionWeek,
                  .semester => l10n.exportActionSemester,
                },
                expanded: true,
                size: .large,
                onPressed: () {
                  final selected = _lessonsForPeriod(lessons, period);
                  Navigator.of(context).pop();
                  if (destination >= 2) {
                    showNinjaToast(
                      context,
                      showCheck: false,
                      message: l10n.exportFormatSoon,
                    );
                  }
                  unawaited(
                    context.read<ScheduleExporterCubit>().exportSchedule(
                      calendarName: context
                          .read<UniversityConfig>()
                          .universityName,
                      lessons: selected,
                      includeShortTypeNames: includeRooms,
                      reminderMinutes: reminders ? const [15] : const [],
                    ),
                  );
                  showNinjaToast(
                    context,
                    message: l10n.exportStarted(
                      lessonCountText(l10n, selected.length),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    ),
  );
}

List<LessonSchedulePart> _lessonsForPeriod(
  List<LessonSchedulePart> lessons,
  _ExportPeriod period,
) {
  final today = dateOnly(DateTime.now());
  return switch (period) {
    .today =>
      lessons
          .where(
            (lesson) => lesson.dates.any((date) => isSameDate(date, today)),
          )
          .toList(),
    .week => () {
      final start = weekStartFor(today);
      final end = start.add(const Duration(days: 7));
      return lessons
          .where(
            (lesson) => lesson.dates.any(
              (date) => !date.isBefore(start) && date.isBefore(end),
            ),
          )
          .toList();
    }(),
    .semester => lessons,
  };
}
