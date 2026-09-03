import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

String formatShortDate(DateTime date, String locale) {
  final text = DateFormat('d MMM', locale).format(date);
  return text.endsWith('.') ? text.substring(0, text.length - 1) : text;
}

String formatShortMonth(DateTime date, String locale) {
  final text = DateFormat('LLL', locale).format(date);
  return text.endsWith('.') ? text.substring(0, text.length - 1) : text;
}

Color attendanceColor(AppColors colors, int percent) {
  if (percent >= 85) return colors.lecture;
  if (percent >= 70) return colors.warn;
  return colors.danger;
}
