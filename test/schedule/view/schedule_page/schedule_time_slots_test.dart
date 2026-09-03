import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_time_slots.dart';

void main() {
  const configured = UniversityConfig.defaultLessonBellSlots;
  test('missing or invalid end times do not create fabricated grid rows', () {
    final day = DateTime(2030, 9, 2);
    final start = day.add(const Duration(hours: 23));
    expect(scheduleSlotForDay(startsAt: start, day: day), isNull);
    expect(
      scheduleSlotForDay(startsAt: start, endsAt: start, day: day),
      isNull,
    );
  });
  test('overnight activities produce clipped slots for both days', () {
    final saturday = DateTime(2026, 9, 5);
    final sunday = DateTime(2026, 9, 6);
    final start = saturday.add(const Duration(hours: 23));
    final end = sunday.add(const Duration(hours: 1));
    final first = scheduleSlotForDay(
      startsAt: start,
      endsAt: end,
      day: saturday,
    )!;
    final second = scheduleSlotForDay(
      startsAt: start,
      endsAt: end,
      day: sunday,
    )!;
    expect((first.startMinutes, first.endMinutes), (1380, 1440));
    expect((second.startMinutes, second.endMinutes), (0, 60));
    expect(
      scheduleSlotForDay(
        startsAt: start,
        endsAt: end,
        day: DateTime(2026, 9, 7),
      ),
      isNull,
    );
  });
  test('keeps six reference slots without late activities', () {
    expect(
      scheduleWeekSlots(configured: configured, occupied: const []),
      configured.take(6),
    );
  });
  test('retains early, break and late lessons instead of losing them', () {
    const events = [
      LessonBellSlotConfig(startMinutes: 420, endMinutes: 500),
      LessonBellSlotConfig(startMinutes: 631, endMinutes: 639),
      LessonBellSlotConfig(startMinutes: 1290, endMinutes: 1350),
    ];
    final slots = scheduleWeekSlots(configured: configured, occupied: events);
    for (final event in events) {
      expect(slots.any((slot) => scheduleSlotsOverlap(slot, event)), isTrue);
    }
    expect(
      slots.map((slot) => slot.startMinutes),
      orderedEquals(
        slots.map((slot) => slot.startMinutes).toList()..sort(),
      ),
    );
  });
  test('respects custom university bell slots and late configured rows', () {
    const custom = [
      LessonBellSlotConfig(startMinutes: 480, endMinutes: 550),
      LessonBellSlotConfig(startMinutes: 570, endMinutes: 640),
    ];
    expect(scheduleWeekSlots(configured: custom, occupied: const []), custom);
    expect(
      scheduleWeekSlots(configured: configured, occupied: [configured.last]),
      configured,
    );
  });
  test('duplicate nonstandard events add only one row', () {
    const early = LessonBellSlotConfig(startMinutes: 420, endMinutes: 500);
    final slots = scheduleWeekSlots(
      configured: configured,
      occupied: const [early, early],
    );
    expect(
      slots.where((slot) => slot.startMinutes == early.startMinutes),
      hasLength(1),
    );
  });
  test('partial intersection retains the actual early start and late end', () {
    const early = LessonBellSlotConfig(startMinutes: 420, endMinutes: 555);
    const late = LessonBellSlotConfig(startMinutes: 1260, endMinutes: 1350);
    final slots = scheduleWeekSlots(
      configured: configured,
      occupied: const [early, late],
    );
    expect(slots.any((slot) => slot.startMinutes == 420), isTrue);
    expect(slots.any((slot) => slot.endMinutes == 1350), isTrue);
  });
}
