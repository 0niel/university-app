// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_readiness.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExamReadiness _$ExamReadinessFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ExamReadiness', json, ($checkedConvert) {
      final val = _ExamReadiness(
        subjectName: $checkedConvert('subject_name', (v) => v as String),
        readiness: $checkedConvert('readiness', (v) => (v as num).toInt()),
      );
      return val;
    }, fieldKeyMap: const {'subjectName': 'subject_name'});

Map<String, dynamic> _$ExamReadinessToJson(_ExamReadiness instance) =>
    <String, dynamic>{
      'subject_name': instance.subjectName,
      'readiness': instance.readiness,
    };
