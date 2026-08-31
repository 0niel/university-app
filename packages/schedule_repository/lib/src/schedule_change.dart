import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule_repository/src/schedule_change_kind.dart';
import 'package:schedule_repository/src/schedule_change_slot.dart';

part 'schedule_change.freezed.dart';
part 'schedule_change.g.dart';

@freezed
abstract class ScheduleChange with _$ScheduleChange {
  const factory ScheduleChange({
    required String id,
    required ScheduleChangeKind kind,
    required String subject,
    required DateTime lessonDate,
    required DateTime createdAt,
    int? lessonNumber,
    @Default(ScheduleChangeSlot()) ScheduleChangeSlot oldValue,
    @Default(ScheduleChangeSlot()) ScheduleChangeSlot newValue,
  }) = _ScheduleChange;

  factory ScheduleChange.fromJson(Map<String, dynamic> json) =>
      _$ScheduleChangeFromJson({
        'id': json['id'].toString(),
        'kind': ScheduleChangeKind.fromWireValue(
          (json['changeKind'] ?? json['change_kind'] ?? '').toString(),
        ).wireValue,
        'subject': (json['subject'] ?? '').toString(),
        'lessonDate': _localDateTime(json['lessonDate'] ?? json['lesson_date']),
        'lessonNumber': _nullableInteger(
          json['lessonNumber'] ?? json['lesson_number'],
        ),
        'oldValue': _map(json['oldValue'] ?? json['old_value']),
        'newValue': _map(json['newValue'] ?? json['new_value']),
        'createdAt': _localDateTime(json['createdAt'] ?? json['created_at']),
      });
}

String _localDateTime(Object? value) {
  return (DateTime.tryParse(value?.toString() ?? '')?.toLocal() ??
          DateTime.now())
      .toIso8601String();
}

int? _nullableInteger(Object? value) => switch (value) {
  final num number => number.toInt(),
  final String text => int.tryParse(text),
  _ => null,
};

Map<String, dynamic> _map(Object? value) {
  if (value is! Map) return const {};
  return value.map((key, item) => MapEntry(key.toString(), item));
}
