import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule/schedule.dart' show normalizeTeacherName;

part 'schedule_change_slot.freezed.dart';
part 'schedule_change_slot.g.dart';

@freezed
abstract class ScheduleChangeSlot with _$ScheduleChangeSlot {
  const factory ScheduleChangeSlot({
    String? start,
    String? end,
    String? subject,
    String? lessonType,
    int? lessonNumber,
    @Default([]) List<DateTime> dates,
    @Default([]) List<String> rooms,
    @Default([]) List<String> teachers,
  }) = _ScheduleChangeSlot;

  const ScheduleChangeSlot._();

  factory ScheduleChangeSlot.fromJson(Map<String, dynamic> json) =>
      _$ScheduleChangeSlotFromJson({
        'start': _time(json, ['start', 'start_time', 'startTime']),
        'end': _time(json, ['end', 'end_time', 'endTime']),
        'subject': _text(json['title'] ?? json['subject']),
        'lessonType': _text(json['lesson_type'] ?? json['lessonType']),
        'lessonNumber': _integer(json['lesson_number'] ?? json['lessonNumber']),
        'dates': _dates(json['dates']),
        'rooms': _names(json['rooms']),
        'teachers': _names(json['teachers']).map(normalizeTeacherName).toList(),
      });

  bool get isEmpty =>
      start == null &&
      end == null &&
      subject == null &&
      lessonType == null &&
      lessonNumber == null &&
      dates.isEmpty &&
      rooms.isEmpty &&
      teachers.isEmpty;
}

List<String> _names(Object? value) {
  if (value is! List) return const [];
  return value.map(_text).whereType<String>().toSet().toList();
}

String? _text(Object? value) {
  if (value is! String || value.trim().isEmpty) return null;
  return value.trim();
}

int? _integer(Object? value) => switch (value) {
  final int number => number,
  final String text => int.tryParse(text),
  _ => null,
};

List<String> _dates(Object? value) {
  if (value is! List) return const [];
  final dates = <String>{};
  for (final item in value) {
    final text = _text(item);
    if (text == null ||
        !RegExp(
          r'^\d{4}-\d{2}-\d{2}(?:T00:00:00(?:\.0+)?(?:Z|[+-]\d{2}:\d{2})?)?$',
        ).hasMatch(text)) {
      continue;
    }
    final calendarDate = text.substring(0, 10);
    final date = DateTime.tryParse(calendarDate);
    if (date != null && date.toIso8601String().startsWith(calendarDate)) {
      dates.add(calendarDate);
    }
  }
  return dates.toList()..sort();
}

String? _time(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final text = _text(json[key]);
    if (text == null) continue;
    final match = RegExp(
      r'^(\d{1,2}):(\d{2})(?::(\d{2})(?:\.\d+)?)?$',
    ).firstMatch(text);
    if (match == null) continue;
    final hours = int.parse(match[1]!);
    final minutes = int.parse(match[2]!);
    final seconds = int.parse(match[3] ?? '0');
    if (hours > 23 || minutes > 59 || seconds > 59) continue;
    return '${hours.toString().padLeft(2, '0')}:${match[2]}';
  }
  return null;
}
