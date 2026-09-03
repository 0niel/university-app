import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

abstract final class EventLayout {
  static const rsvpHeight = 40.0;
  static const rsvpTouchPadding = 2.0;
  static const double emojiTileSize = AppControlSize.iconTileLarge;
}

final _campusRoomPattern = RegExp(r'^[a-zа-яё]{1,3}-?\d', caseSensitive: false);

bool looksLikeCampusRoom(String place) =>
    _campusRoomPattern.hasMatch(place.trim());

bool isSameCalendarDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String eventTimeRange(BuildContext context, CampusEvent event) {
  final locale = Localizations.localeOf(context).toString();
  final dayFormat = DateFormat('EEE, d MMM', locale);
  final timeFormat = DateFormat.Hm(locale);
  final start = event.startsAt;
  final end = event.endsAt;
  final day = _capitalize(dayFormat.format(start));
  if (end == null) return '$day · ${timeFormat.format(start)}';
  if (isSameCalendarDay(start, end)) {
    return '$day · ${timeFormat.format(start)}–${timeFormat.format(end)}';
  }
  final endDay = _capitalize(dayFormat.format(end));
  return '$day ${timeFormat.format(start)} – $endDay ${timeFormat.format(end)}';
}

String _capitalize(String value) =>
    value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';
