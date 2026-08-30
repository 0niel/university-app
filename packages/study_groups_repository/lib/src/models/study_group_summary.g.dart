// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_group_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudyGroupSummary _$StudyGroupSummaryFromJson(Map<String, dynamic> json) =>
    _StudyGroupSummary(
      id: json['id'] as String,
      name: json['name'] as String,
      emoji: json['emoji'] as String? ?? '🎓',
      description: json['description'] as String? ?? '',
      memberCount: (json['memberCount'] as num?)?.toInt() ?? 0,
      ownerName: json['ownerName'] as String? ?? '',
      hasRequested: json['hasRequested'] as bool? ?? false,
    );

Map<String, dynamic> _$StudyGroupSummaryToJson(_StudyGroupSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'emoji': instance.emoji,
      'description': instance.description,
      'memberCount': instance.memberCount,
      'ownerName': instance.ownerName,
      'hasRequested': instance.hasRequested,
    };
