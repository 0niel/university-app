// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edu_program.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EduProgram _$EduProgramFromJson(Map<String, dynamic> json) => EduProgram(
      eduProgram: json['eduProgram'] as String,
      eduProgramCode: json['eduProgramCode'] as String,
      department: json['department'] as String,
      prodDepartment: json['prodDepartment'] as String,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$EduProgramToJson(EduProgram instance) => <String, dynamic>{
      'eduProgram': instance.eduProgram,
      'eduProgramCode': instance.eduProgramCode,
      'department': instance.department,
      'prodDepartment': instance.prodDepartment,
      'type': instance.type,
    };
