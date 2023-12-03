// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'teacher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Teacher _$TeacherFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Teacher',
      json,
      ($checkedConvert) {
        final val = Teacher(
          name: $checkedConvert('name', (v) => v as String),
          uid: $checkedConvert('uid', (v) => v as String?),
          photoUrl: $checkedConvert('photo_url', (v) => v as String?),
          email: $checkedConvert('email', (v) => v as String?),
          phone: $checkedConvert('phone', (v) => v as String?),
          post: $checkedConvert('post', (v) => v as String?),
          department: $checkedConvert('department', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'photoUrl': 'photo_url'},
    );

Map<String, dynamic> _$TeacherToJson(Teacher instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('uid', instance.uid);
  val['name'] = instance.name;
  writeNotNull('photo_url', instance.photoUrl);
  writeNotNull('email', instance.email);
  writeNotNull('phone', instance.phone);
  writeNotNull('post', instance.post);
  writeNotNull('department', instance.department);
  return val;
}
