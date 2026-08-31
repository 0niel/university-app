// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'calendar_schedule_part.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CalendarSchedulePart _$CalendarSchedulePartFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  '_CalendarSchedulePart',
  json,
  ($checkedConvert) {
    final val = _CalendarSchedulePart(
      title: $checkedConvert('title', (v) => v as String),
      dates: $checkedConvert(
        'dates',
        (v) => const DatesConverter().fromJson(v as List),
      ),
      kind: $checkedConvert(
        'kind',
        (v) => v as String? ?? 'event',
        readValue: _readKind,
      ),
      description: $checkedConvert('description', (v) => v as String?),
      startsAt: $checkedConvert('starts_at', (v) => _dateTimeFromJson(v)),
      endsAt: $checkedConvert('ends_at', (v) => _dateTimeFromJson(v)),
      isAllDay: $checkedConvert('is_all_day', (v) => v as bool? ?? false),
      location: $checkedConvert('location', (v) => v as String?),
      uid: $checkedConvert('uid', (v) => v as String?),
      sourceLinks: $checkedConvert(
        'source_links',
        (v) => v as Map<String, dynamic>?,
      ),
      type: $checkedConvert(
        'type',
        (v) => v == null ? CalendarSchedulePart.identifier : _normalizeType(v),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'startsAt': 'starts_at',
    'endsAt': 'ends_at',
    'isAllDay': 'is_all_day',
    'sourceLinks': 'source_links',
  },
);

Map<String, dynamic> _$CalendarSchedulePartToJson(
  _CalendarSchedulePart instance,
) => <String, dynamic>{
  'title': instance.title,
  'dates': const DatesConverter().toJson(instance.dates),
  'kind': instance.kind,
  'description': ?instance.description,
  'starts_at': ?_dateTimeToJson(instance.startsAt),
  'ends_at': ?_dateTimeToJson(instance.endsAt),
  'is_all_day': instance.isAllDay,
  'location': ?instance.location,
  'uid': ?instance.uid,
  'source_links': ?instance.sourceLinks,
  'type': instance.type,
};
