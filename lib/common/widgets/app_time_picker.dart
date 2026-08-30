import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'app_slot_chip.dart';
part 'app_time_picker_sheet.dart';
part 'app_time_wheel_group.dart';
part 'app_time_wheels.dart';

typedef PickedTime = ({int hour, int minute});

typedef TimeSlot = ({String label, PickedTime start, PickedTime end});

String _two(int value) => value < 10 ? '0$value' : '$value';

String formatPickedTime(PickedTime time) =>
    '${_two(time.hour)}:${_two(time.minute)}';

int _minutesOf(PickedTime time) => time.hour * 60 + time.minute;

Future<PickedTime?> showAppTimePicker(
  BuildContext context, {
  required PickedTime initial,
  String? title,
}) {
  return showAppSheet<PickedTime>(
    context,
    title: title ?? context.l10n.pickerTimeTitle,
    contentPadding: EdgeInsets.zero,
    child: AppTimePickerSheet(start: initial),
  );
}

Future<(PickedTime, PickedTime)?> showAppTimeRangePicker(
  BuildContext context, {
  required PickedTime start,
  required PickedTime end,
  String? title,
  List<TimeSlot> quickSlots = const [],
}) {
  return showAppSheet<(PickedTime, PickedTime)>(
    context,
    title: title ?? context.l10n.pickerTimeRangeTitle,
    contentPadding: EdgeInsets.zero,
    child: AppTimePickerSheet(
      start: start,
      end: end,
      isRange: true,
      quickSlots: quickSlots,
    ),
  );
}
