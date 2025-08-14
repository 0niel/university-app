// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'campus.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Campus _$CampusFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Campus',
      json,
      ($checkedConvert) {
        final val = Campus(
          name: $checkedConvert('name', (v) => v as String),
          shortName: $checkedConvert('short_name', (v) => v as String?),
          latitude: $checkedConvert('latitude', (v) => (v as num?)?.toDouble()),
          longitude: $checkedConvert('longitude', (v) => (v as num?)?.toDouble()),
          uid: $checkedConvert('uid', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'shortName': 'short_name'},
    );

Map<String, dynamic> _$CampusToJson(Campus instance) {
  final val = <String, dynamic>{
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('short_name', instance.shortName);
  writeNotNull('latitude', instance.latitude);
  writeNotNull('longitude', instance.longitude);
  writeNotNull('uid', instance.uid);
  return val;
}
