import 'package:rtu_mirea_app/config/config.dart';

LessonBellSlotConfig? scheduleSlotForDay({
  required DateTime startsAt,
  required DateTime day,
  DateTime? endsAt,
}) {
  final start = DateTime(day.year, day.month, day.day);
  final end = endsAt;
  if (end == null || !end.isAfter(startsAt)) return null;
  if (!startsAt.isBefore(start.add(const Duration(days: 1))) ||
      !end.isAfter(start)) {
    return null;
  }
  return LessonBellSlotConfig(
    startMinutes: startsAt.difference(start).inMinutes.clamp(0, 1440),
    endMinutes: end.difference(start).inMinutes.clamp(0, 1440),
  );
}

bool scheduleSlotsOverlap(LessonBellSlotConfig a, LessonBellSlotConfig b) =>
    a.startMinutes < b.endMinutes && a.endMinutes > b.startMinutes;

List<LessonBellSlotConfig> scheduleWeekSlots({
  required List<LessonBellSlotConfig> configured,
  required Iterable<LessonBellSlotConfig> occupied,
}) {
  final source = configured.isEmpty
      ? UniversityConfig.defaultLessonBellSlots
      : configured;
  final ordered = [...source]
    ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));
  final events = occupied
      .where((slot) => slot.endMinutes > slot.startMinutes)
      .toList();
  var visible = ordered.length.clamp(0, 6);
  for (var index = visible; index < ordered.length; index++) {
    if (events.any((event) => scheduleSlotsOverlap(event, ordered[index]))) {
      visible = index + 1;
    }
  }
  final slots = ordered.take(visible).toList();
  for (final event in events) {
    var cursor = event.startMinutes;
    final existing = [...slots]
      ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));
    for (final slot in existing) {
      if (slot.endMinutes <= cursor) continue;
      if (slot.startMinutes >= event.endMinutes) break;
      if (slot.startMinutes > cursor) {
        slots.add(
          LessonBellSlotConfig(
            startMinutes: cursor,
            endMinutes: slot.startMinutes,
          ),
        );
      }
      if (slot.endMinutes > cursor) cursor = slot.endMinutes;
      if (cursor >= event.endMinutes) break;
    }
    if (cursor < event.endMinutes) {
      slots.add(
        LessonBellSlotConfig(
          startMinutes: cursor,
          endMinutes: event.endMinutes,
        ),
      );
    }
  }
  return slots..sort((a, b) {
    final start = a.startMinutes.compareTo(b.startMinutes);
    return start != 0 ? start : a.endMinutes.compareTo(b.endMinutes);
  });
}
