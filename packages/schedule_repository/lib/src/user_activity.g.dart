// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserActivity _$UserActivityFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_UserActivity', json, ($checkedConvert) {
      final val = _UserActivity(
        id: $checkedConvert('id', (v) => v as String),
        type: $checkedConvert(
          'type',
          (v) => $enumDecode(_$UserActivityTypeEnumMap, v),
        ),
        title: $checkedConvert('title', (v) => v as String),
        startsAt: $checkedConvert(
          'startsAt',
          (v) => DateTime.parse(v as String),
        ),
        place: $checkedConvert('place', (v) => v as String?),
        subtitle: $checkedConvert('subtitle', (v) => v as String?),
        lessonUid: $checkedConvert('lessonUid', (v) => v as String?),
        endsAt: $checkedConvert(
          'endsAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$UserActivityToJson(_UserActivity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$UserActivityTypeEnumMap[instance.type]!,
      'title': instance.title,
      'startsAt': instance.startsAt.toIso8601String(),
      'place': instance.place,
      'subtitle': instance.subtitle,
      'lessonUid': instance.lessonUid,
      'endsAt': instance.endsAt?.toIso8601String(),
    };

const _$UserActivityTypeEnumMap = {
  UserActivityType.event: 'event',
  UserActivityType.retake: 'retake',
  UserActivityType.extra: 'extra',
  UserActivityType.personal: 'personal',
  UserActivityType.consult: 'consult',
};
