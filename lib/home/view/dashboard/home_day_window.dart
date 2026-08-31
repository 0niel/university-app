import 'dart:math' as math;

import 'package:rtu_mirea_app/home/view/dashboard/home_day_step.dart';

const kHomeDayWindowLength = 14;

const kHomeDayWindowTodayIndex = 2;

List<DateTime> homeDayWindow(DateTime now) => [
  for (var index = 0; index < kHomeDayWindowLength; index++)
    DateTime(now.year, now.month, now.day + index - kHomeDayWindowTodayIndex),
];

HomeDayStep? homeDaySwipeStep({
  required double dragOffset,
  required double velocity,
  required double width,
}) {
  const velocityThreshold = 240;
  final distance = math.max<double>(48, width * .18);
  if (velocity <= -velocityThreshold) return HomeDayStep.next;
  if (velocity >= velocityThreshold) return HomeDayStep.previous;
  if (dragOffset <= -distance) return HomeDayStep.next;
  if (dragOffset >= distance) return HomeDayStep.previous;
  return null;
}

int? homeDayStepTarget({
  required int selectedIndex,
  required int dayCount,
  required HomeDayStep step,
}) {
  final target = selectedIndex + (step == HomeDayStep.next ? 1 : -1);
  return target < 0 || target >= dayCount ? null : target;
}

double homeDayRailOffset({
  required int index,
  required double cellWidth,
  required double separator,
  required double leadingInset,
  required double viewport,
  required double maxScrollExtent,
}) {
  final start = leadingInset + index * (cellWidth + separator);
  final centered = start - (viewport - cellWidth) / 2;
  final limit = maxScrollExtent < 0 ? 0.0 : maxScrollExtent;
  return centered.clamp(0.0, limit);
}
