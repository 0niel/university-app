// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edu_program.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EduProgram _$EduProgramFromJson(Map<String, dynamic> json) => EduProgram(
      eduProgram: json['NAME'] as String,
      eduProgramCode: json['PROPERTIES.OKSO_CODE.VALUE'] as String,
      department: json['PROPERTIES.DEPARTMENT.VALUE_TEXT'] as String,
      prodDepartment: json['PROPERTIES.PROD_DEPARTMENT.VALUE_TEXT'] as String,
      type: json['PROPERTIES.TYPE.VALUE_TEXT'] as String?,
    );

Map<String, dynamic> _$EduProgramToJson(EduProgram instance) =>
    <String, dynamic>{
      'NAME': instance.eduProgram,
      'PROPERTIES.OKSO_CODE.VALUE': instance.eduProgramCode,
      'PROPERTIES.DEPARTMENT.VALUE_TEXT': instance.department,
      'PROPERTIES.PROD_DEPARTMENT.VALUE_TEXT': instance.prodDepartment,
      'PROPERTIES.TYPE.VALUE_TEXT': instance.type,
    };
