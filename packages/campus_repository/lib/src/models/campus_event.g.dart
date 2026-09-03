// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campus_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CampusEvent _$CampusEventFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_CampusEvent', json, ($checkedConvert) {
  final val = _CampusEvent(
    id: $checkedConvert('id', (v) => v as String? ?? ''),
    title: $checkedConvert('title', (v) => v as String? ?? ''),
    startsAt: $checkedConvert('startsAt', (v) => requiredDateTimeFromJson(v)),
    endsAt: $checkedConvert('endsAt', (v) => dateTimeFromJson(v)),
    description: $checkedConvert('description', (v) => v as String? ?? ''),
    emoji: $checkedConvert('emoji', (v) => v as String? ?? '🎉'),
    category: $checkedConvert('category', (v) => v as String? ?? 'other'),
    place: $checkedConvert('place', (v) => v as String? ?? ''),
    goingCount: $checkedConvert('goingCount', (v) => (v as num?)?.toInt() ?? 0),
    isGoing: $checkedConvert('isGoing', (v) => v as bool? ?? false),
    isMine: $checkedConvert('isMine', (v) => v as bool? ?? false),
    goingNames: $checkedConvert(
      'goingNames',
      (v) => v == null ? const <String>[] : stringListFromJson(v),
    ),
  );
  return val;
});

Map<String, dynamic> _$CampusEventToJson(_CampusEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'startsAt': requiredDateTimeToJson(instance.startsAt),
      'endsAt': dateTimeToJson(instance.endsAt),
      'description': instance.description,
      'emoji': instance.emoji,
      'category': instance.category,
      'place': instance.place,
      'goingCount': instance.goingCount,
      'isGoing': instance.isGoing,
      'isMine': instance.isMine,
      'goingNames': stringListToJson(instance.goingNames),
    };
