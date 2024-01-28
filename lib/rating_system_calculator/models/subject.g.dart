// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subject _$SubjectFromJson(Map<String, dynamic> json) => Subject(
      name: json['name'] as String,
      dates: (json['dates'] as List<dynamic>).map((e) => DateTime.parse(e as String)).toList(),
      mainScore: (json['mainScore'] as num?)?.toDouble(),
      additionalScore: (json['additionalScore'] as num?)?.toDouble(),
      classScore: (json['classScore'] as num?)?.toDouble(),
      visitedDays: (json['visitedDays'] as List<dynamic>?)?.map((e) => DateTime.parse(e as String)).toList(),
    );

Map<String, dynamic> _$SubjectToJson(Subject instance) => <String, dynamic>{
      'name': instance.name,
      'dates': instance.dates.map((e) => e.toIso8601String()).toList(),
      'mainScore': instance.mainScore,
      'additionalScore': instance.additionalScore,
      'classScore': instance.classScore,
      'visitedDays': instance.visitedDays?.map((e) => e.toIso8601String()).toList(),
    };
