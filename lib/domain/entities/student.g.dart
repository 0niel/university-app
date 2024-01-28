// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Student _$StudentFromJson(Map<String, dynamic> json) => Student(
      id: json['id'] as String,
      isActive: json['isActive'] as bool,
      course: json['course'] as int,
      personalNumber: json['personalNumber'] as String,
      educationStartDate: json['educationStartDate'] as String,
      educationEndDate: json['educationEndDate'] as String,
      academicGroup: json['academicGroup'] as String,
      code: json['code'] as String,
      eduProgram: EduProgram.fromJson(json['eduProgram'] as Map<String, dynamic>),
      status: json['status'] as String,
    );

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
      'id': instance.id,
      'isActive': instance.isActive,
      'course': instance.course,
      'personalNumber': instance.personalNumber,
      'educationStartDate': instance.educationStartDate,
      'educationEndDate': instance.educationEndDate,
      'academicGroup': instance.academicGroup,
      'code': instance.code,
      'eduProgram': instance.eduProgram,
      'status': instance.status,
    };
