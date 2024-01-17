// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Score _$ScoreFromJson(Map<String, dynamic> json) => Score(
      subjectName: json['subjectName'] as String,
      result: json['result'] as String,
      type: json['type'] as String,
      comission: json['comission'] as String?,
      courseWork: json['courseWork'] as String?,
      exam: json['exam'] as String?,
      credit: json['credit'] as String?,
      date: json['date'] as String,
      year: json['year'] as String,
    );

Map<String, dynamic> _$ScoreToJson(Score instance) => <String, dynamic>{
      'subjectName': instance.subjectName,
      'result': instance.result,
      'type': instance.type,
      'comission': instance.comission,
      'courseWork': instance.courseWork,
      'exam': instance.exam,
      'credit': instance.credit,
      'date': instance.date,
      'year': instance.year,
    };
