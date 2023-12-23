// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Group',
      json,
      ($checkedConvert) {
        final val = Group(
          name: $checkedConvert('name', (v) => v as String),
          uid: $checkedConvert('uid', (v) => v as String?),
        );
        return val;
      },
    );

Map<String, dynamic> _$GroupToJson(Group instance) {
  final val = <String, dynamic>{
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('uid', instance.uid);
  return val;
}
