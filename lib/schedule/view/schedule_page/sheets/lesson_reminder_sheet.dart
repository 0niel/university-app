import 'dart:async';
import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/common/widgets/app_time_picker.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets/widgets/schedule_sheet_widgets.dart';
import 'package:schedule_repository/schedule_repository.dart';

Future<void> showLessonReminderSheet(
  BuildContext context, {
  required LessonSchedulePart lesson,
  required DateTime day,
}) {
  final l10n = context.l10n;
  final repository = context.read<ScheduleRepository>();
  final room = lesson.classrooms.firstOrNull?.name;

  var option = 0;
  PickedTime? customTime;
  var push = true;
  var withRoute = true;
  var traffic = false;
  var saving = false;

  DateTime lessonStart() {
    final start = lesson.lessonBells.startTime;
    return DateTime(day.year, day.month, day.day, start.hour, start.minute);
  }

  String hhmm(int hour, int minute) =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  return showAppSheet<void>(
    context,
    title: l10n.reminderSheetTitle,
    subtitle: '${lesson.subject} · ${lesson.lessonBells.startTime}',
    backgroundColor: context.ninja.canvas,
    child: StatefulBuilder(
      builder: (context, setState) {
        final start = lessonStart();
        final options = [
          (l10n.reminder15Min, l10n.reminder15MinSub),
          (l10n.reminder5Min, l10n.reminder5MinSub),
          (l10n.reminderMorning, l10n.reminderMorningSub),
          (
            l10n.reminderCustom,
            switch (customTime) {
              final time? => l10n.reminderCustomAt(
                hhmm(time.hour, time.minute),
              ),
              null => l10n.reminderCustomHint,
            },
          ),
        ];

        Future<void> pickCustomTime() async {
          final picked = await showAppTimePicker(
            context,
            initial: (hour: start.hour, minute: start.minute),
          );
          if (picked != null) {
            setState(() {
              customTime = picked;
              option = 3;
            });
          }
        }

        DateTime resolveFireAt() {
          final custom = customTime;
          final base = switch (option) {
            0 => start.subtract(const Duration(minutes: 15)),
            1 => start.subtract(const Duration(minutes: 5)),
            2 => DateTime(day.year, day.month, day.day, 8),
            _ =>
              custom != null
                  ? DateTime(
                      day.year,
                      day.month,
                      day.day,
                      custom.hour,
                      custom.minute,
                    )
                  : start.subtract(const Duration(minutes: 15)),
          };
          return traffic ? base.subtract(const Duration(minutes: 5)) : base;
        }

        Future<void> save() async {
          if (saving) return;
          setState(() => saving = true);
          final fireAt = resolveFireAt();
          final fireLabel = hhmm(fireAt.hour, fireAt.minute);
          final bell = lesson.lessonBells.startTime;
          final startLabel = hhmm(bell.hour, bell.minute);
          try {
            await repository.createReminder(
              fireAt: fireAt,
              title: lesson.subject,
              body:
                  '${l10n.reminderAtTime(startLabel)}'
                  '${withRoute && room != null ? ' · $room' : ''}',
              route: withRoute ? '/services/map' : '/schedule',
            );
            if (context.mounted) {
              Navigator.of(context).pop();
              await _showReminderSuccess(
                context,
                fireTime: fireLabel,
                room: withRoute ? room : null,
              );
            }
          } on Exception catch (e, st) {
            log(
              'Failed to create lesson reminder',
              error: e,
              stackTrace: st,
              name: 'showLessonReminderSheet',
            );
            if (context.mounted) {
              setState(() => saving = false);
              showNinjaToast(
                context,
                showCheck: false,
                message: l10n.scheduleActionFailed,
              );
            }
          }
        }

        return Padding(
          padding: const .fromLTRB(0, 4, 0, 24),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              ScheduleSheetSectionLabel(
                l10n.reminderWhenSection,
                first: true,
              ),
              for (final (index, item) in options.indexed)
                ScheduleSheetRadioRow(
                  title: item.$1,
                  subtitle: item.$2,
                  selected: option == index,
                  first: index == 0,
                  onTap: () {
                    if (index == 3) {
                      unawaited(pickCustomTime());
                    } else {
                      setState(() => option = index);
                    }
                  },
                ),
              ScheduleSheetSectionLabel(l10n.reminderHowSection),
              ScheduleSheetToggleRow(
                title: l10n.reminderPush,
                value: push,
                first: true,
                onChanged: (value) => setState(() => push = value),
              ),
              ScheduleSheetToggleRow(
                title: l10n.reminderRoute,
                value: withRoute,
                onChanged: (value) => setState(() => withRoute = value),
              ),
              ScheduleSheetToggleRow(
                title: l10n.reminderTraffic,
                subtitle: l10n.reminderTrafficSub,
                value: traffic,
                onChanged: (value) => setState(() => traffic = value),
              ),
              const SizedBox(height: 22),
              NinjaButton.primary(
                label: l10n.reminderSet,
                expanded: true,
                size: .large,
                loading: saving,
                onPressed: saving ? null : () => unawaited(save()),
              ),
            ],
          ),
        );
      },
    ),
  );
}

Future<void> _showReminderSuccess(
  BuildContext context, {
  required String fireTime,
  String? room,
}) {
  final l10n = context.l10n;
  return showNinjaDialog(
    context,
    builder: (dialogContext) {
      Future<void>.delayed(const Duration(milliseconds: 1600), () {
        if (dialogContext.mounted && Navigator.of(dialogContext).canPop()) {
          Navigator.of(dialogContext).pop();
        }
      });
      return NinjaDialog(
        title: l10n.reminderSuccessTitle,
        message: room != null
            ? l10n.reminderSuccessBodyRoute(fireTime, room)
            : l10n.reminderSuccessBody(fireTime),
      );
    },
  );
}
