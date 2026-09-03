import 'package:campus_repository/campus_repository.dart';
import 'package:rtu_mirea_app/config/lesson_bell_slot_config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

const freeRoomUrgentMinutes = 90;

int? freeRoomMinutesLeft(FreeRoom room, DateTime now) {
  final until = room.freeUntil;
  if (until == null) return null;
  final minutes = until.difference(now).inMinutes;
  return minutes < 0 ? 0 : minutes;
}

bool freeRoomIsUrgent(int? minutesLeft) =>
    minutesLeft != null && minutesLeft < freeRoomUrgentMinutes;

String freeRoomLeftLabel(AppLocalizations l10n, int minutes) {
  if (minutes < 60) return l10n.freeRoomsLeftMinutes(minutes);
  final hours = minutes ~/ 60;
  final rest = minutes % 60;
  return rest == 0
      ? l10n.freeRoomsLeftHours(hours)
      : l10n.freeRoomsLeftHoursMinutes(hours, rest);
}

String? nextLessonStartLabel(List<LessonBellSlotConfig> slots, DateTime now) {
  final nowMinutes = now.hour * 60 + now.minute;
  for (final slot in slots) {
    if (slot.startMinutes > nowMinutes) return slot.label;
  }
  return null;
}
