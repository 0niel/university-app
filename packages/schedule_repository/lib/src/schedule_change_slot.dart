import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_change_slot.freezed.dart';
part 'schedule_change_slot.g.dart';

@freezed
abstract class ScheduleChangeSlot with _$ScheduleChangeSlot {
  const factory ScheduleChangeSlot({
    String? start,
    String? end,
    @Default([]) List<String> rooms,
    @Default([]) List<String> teachers,
  }) = _ScheduleChangeSlot;

  const ScheduleChangeSlot._();

  factory ScheduleChangeSlot.fromJson(Map<String, dynamic> json) =>
      _$ScheduleChangeSlotFromJson({
        'start': _hoursAndMinutes(json['start']),
        'end': _hoursAndMinutes(json['end']),
        'rooms': _names(json['rooms']),
        'teachers': _names(json['teachers']),
      });

  bool get isEmpty =>
      start == null && end == null && rooms.isEmpty && teachers.isEmpty;
}

List<String> _names(Object? value) {
  if (value is! List) return const [];
  return value.map((item) => item.toString()).toList();
}

String? _hoursAndMinutes(Object? value) {
  final text = value?.toString();
  if (text == null || text.isEmpty) return null;
  return text.length >= 5 ? text.substring(0, 5) : text;
}
