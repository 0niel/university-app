import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/free_rooms/cubit/free_rooms_time.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class FreeRoomViewModel {
  const FreeRoomViewModel({
    required this.room,
    required this.now,
    this.floor,
    this.booked = false,
    this.locale = 'ru',
  });

  final FreeRoom room;
  final DateTime now;
  final int? floor;
  final bool booked;
  final String locale;

  String get name => room.room;

  String get campus => room.campus ?? room.building;

  int? get minutesLeft => freeRoomMinutesLeft(room, now);

  bool get urgent => freeRoomIsUrgent(minutesLeft);

  String get tileLabel {
    final level = floor;
    if (level != null) return '$level';
    final building = room.building;
    return building.isEmpty
        ? (name.isEmpty ? '—' : name.characters.first)
        : building;
  }

  String? get untilTime {
    final until = room.freeUntil;
    if (until == null) return null;
    return DateFormat.Hm(locale).format(until.toLocal());
  }

  String subtitle(AppLocalizations l10n) {
    final where = campus;
    if (where.isEmpty) return l10n.freeRoomsKind;
    return '${l10n.freeRoomsKind} · $where';
  }

  String untilLabel(AppLocalizations l10n) {
    final time = untilTime;
    return time == null
        ? l10n.freeRoomsUntilEndOfDay
        : l10n.freeRoomsFreeUntil(time);
  }

  String? leftLabel(AppLocalizations l10n) {
    final left = minutesLeft;
    return left == null ? null : freeRoomLeftLabel(l10n, left);
  }
}
