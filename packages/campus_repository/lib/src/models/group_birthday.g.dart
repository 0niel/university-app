// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_birthday.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupBirthday _$GroupBirthdayFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_GroupBirthday', json, ($checkedConvert) {
      final val = _GroupBirthday(
        name: $checkedConvert('name', (v) => v as String? ?? ''),
        date: $checkedConvert('date', (v) => requiredDateTimeFromJson(v)),
        isMe: $checkedConvert('isMe', (v) => v as bool? ?? false),
      );
      return val;
    });

Map<String, dynamic> _$GroupBirthdayToJson(_GroupBirthday instance) =>
    <String, dynamic>{
      'name': instance.name,
      'date': requiredDateTimeToJson(instance.date),
      'isMe': instance.isMe,
    };
