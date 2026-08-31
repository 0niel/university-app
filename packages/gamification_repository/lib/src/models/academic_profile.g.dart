// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'academic_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AcademicProfile _$AcademicProfileFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_AcademicProfile', json, ($checkedConvert) {
      final val = _AcademicProfile(
        handle: $checkedConvert('handle', (v) => v as String?),
        group: $checkedConvert('group', (v) => v as String?),
        course: $checkedConvert('course', (v) => (v as num?)?.toInt()),
        fullName: $checkedConvert('fullName', (v) => v as String?),
        studentCardNumber: $checkedConvert(
          'studentCardNumber',
          (v) => v as String?,
        ),
        cardValidUntil: $checkedConvert(
          'cardValidUntil',
          (v) => dateTimeFromJson(v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$AcademicProfileToJson(_AcademicProfile instance) =>
    <String, dynamic>{
      'handle': instance.handle,
      'group': instance.group,
      'course': instance.course,
      'fullName': instance.fullName,
      'studentCardNumber': instance.studentCardNumber,
      'cardValidUntil': dateTimeToJson(instance.cardValidUntil),
    };
