import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:table_calendar/table_calendar.dart';

part 'app_date_picker_day_cell.dart';
part 'app_date_picker_nav_button.dart';
part 'app_date_picker_sheet.dart';
part 'app_flat_calendar.dart';
part 'app_multi_date_picker_sheet.dart';

typedef DateQuickChip = ({String label, DateTime date});

DateTime _dayOnly(DateTime date) => .new(date.year, date.month, date.day);

bool _sameDay(DateTime first, DateTime second) =>
    first.year == second.year &&
    first.month == second.month &&
    first.day == second.day;

DateTime _clampDate(DateTime date, DateTime first, DateTime last) =>
    date.isBefore(first) ? first : (date.isAfter(last) ? last : date);

List<DateQuickChip> defaultDateQuickChips(BuildContext context) {
  final l10n = context.l10n;
  final now = _dayOnly(DateTime.now());
  return [
    (label: l10n.pickerToday, date: now),
    (label: l10n.pickerTomorrow, date: now.add(const Duration(days: 1))),
    (label: l10n.pickerNextWeek, date: now.add(const Duration(days: 7))),
  ];
}

Future<DateTime?> showAppDatePicker(
  BuildContext context, {
  required DateTime initial,
  DateTime? firstDate,
  DateTime? lastDate,
  String? title,
  List<DateQuickChip>? quickChips,
  bool Function(DateTime)? selectableDayPredicate,
}) {
  return showAppSheet<DateTime>(
    context,
    title: title ?? context.l10n.pickerDateTitle,
    contentPadding: EdgeInsets.zero,
    child: AppDatePickerSheet(
      initial: _dayOnly(initial),
      firstDate:
          firstDate ?? DateTime.now().subtract(const Duration(days: 365)),
      lastDate: lastDate ?? DateTime.now().add(const Duration(days: 365 * 2)),
      quickChips: quickChips ?? defaultDateQuickChips(context),
      dateEnabledBuilder: selectableDayPredicate,
    ),
  );
}

Future<List<DateTime>?> showAppMultiDatePicker(
  BuildContext context, {
  List<DateTime> selected = const [],
  DateTime? firstDate,
  DateTime? lastDate,
  String? title,
  bool Function(DateTime)? selectableDayPredicate,
}) {
  return showAppSheet<List<DateTime>>(
    context,
    title: title ?? context.l10n.pickerDatesTitle,
    child: AppMultiDatePickerSheet(
      selected: selected.map(_dayOnly).toList(),
      firstDate:
          firstDate ?? DateTime.now().subtract(const Duration(days: 365)),
      lastDate: lastDate ?? DateTime.now().add(const Duration(days: 365 * 2)),
      dateEnabledBuilder: selectableDayPredicate,
    ),
  );
}
