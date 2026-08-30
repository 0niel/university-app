import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule/src/dates_converter.dart';
import 'package:schedule/src/schedule_part.dart';

part 'calendar_schedule_part.freezed.dart';
part 'calendar_schedule_part.g.dart';

@freezed
abstract class CalendarSchedulePart
    with _$CalendarSchedulePart
    implements SchedulePart {
  const factory CalendarSchedulePart({
    required String title,
    @DatesConverter() required List<DateTime> dates,
    @JsonKey(readValue: _readKind) @Default('event') String kind,
    String? description,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? startsAt,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? endsAt,
    @Default(false) bool isAllDay,
    String? location,
    String? uid,
    Map<String, Object?>? sourceLinks,
    @JsonKey(fromJson: _normalizeType)
    @Default(CalendarSchedulePart.identifier)
    String type,
  }) = _CalendarSchedulePart;

  factory CalendarSchedulePart.fromJson(Map<String, dynamic> json) =>
      _$CalendarSchedulePartFromJson(json);

  static const identifier = '__calendar_event__';
}

DateTime? _dateTimeFromJson(Object? value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}

String? _dateTimeToJson(DateTime? value) => value?.toIso8601String();

Object? _readKind(Map<dynamic, dynamic> json, String key) {
  final kind = json[key];
  if (kind != null) return kind;

  final type = json['type'];
  return type == CalendarSchedulePart.identifier ? null : type;
}

String _normalizeType(Object? _) => CalendarSchedulePart.identifier;
