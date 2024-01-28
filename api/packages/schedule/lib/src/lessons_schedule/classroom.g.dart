// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'classroom.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Classroom _$ClassroomFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Classroom',
      json,
      ($checkedConvert) {
        final val = Classroom(
          name: $checkedConvert('name', (v) => v as String),
          uid: $checkedConvert('uid', (v) => v as String?),
          campus: $checkedConvert('campus', (v) => v == null ? null : Campus.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$ClassroomToJson(Classroom instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('uid', instance.uid);
  val['name'] = instance.name;
  writeNotNull('campus', instance.campus?.toJson());
  return val;
}
