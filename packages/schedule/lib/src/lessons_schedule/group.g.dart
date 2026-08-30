// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Group _$GroupFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_Group', json, ($checkedConvert) {
      final val = _Group(
        name: $checkedConvert('name', (v) => v as String),
        uid: $checkedConvert('uid', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$GroupToJson(_Group instance) => <String, dynamic>{
  'name': instance.name,
  'uid': ?instance.uid,
};
