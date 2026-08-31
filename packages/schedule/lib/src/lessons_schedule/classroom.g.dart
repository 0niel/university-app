// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'classroom.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Classroom _$ClassroomFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_Classroom', json, ($checkedConvert) {
      final val = _Classroom(
        name: $checkedConvert('name', (v) => v as String),
        uid: $checkedConvert('uid', (v) => v as String?),
        campus: $checkedConvert(
          'campus',
          (v) => v == null ? null : Campus.fromJson(v as Map<String, dynamic>),
        ),
        url: $checkedConvert('url', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$ClassroomToJson(_Classroom instance) =>
    <String, dynamic>{
      'name': instance.name,
      'uid': ?instance.uid,
      'campus': ?instance.campus?.toJson(),
      'url': ?instance.url,
    };
