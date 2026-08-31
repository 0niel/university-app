// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'teacher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Teacher _$TeacherFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_Teacher', json, ($checkedConvert) {
      final val = _Teacher(
        name: $checkedConvert('name', (v) => v as String),
        uid: $checkedConvert('uid', (v) => v as String?),
        photoUrl: $checkedConvert('photo_url', (v) => v as String?),
        email: $checkedConvert('email', (v) => v as String?),
        phone: $checkedConvert('phone', (v) => v as String?),
        post: $checkedConvert('post', (v) => v as String?),
        department: $checkedConvert('department', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {'photoUrl': 'photo_url'});

Map<String, dynamic> _$TeacherToJson(_Teacher instance) => <String, dynamic>{
  'name': instance.name,
  'uid': ?instance.uid,
  'photo_url': ?instance.photoUrl,
  'email': ?instance.email,
  'phone': ?instance.phone,
  'post': ?instance.post,
  'department': ?instance.department,
};
