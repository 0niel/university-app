// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudyGroup _$StudyGroupFromJson(Map<String, dynamic> json) => _StudyGroup(
  id: json['id'] as String,
  name: json['name'] as String,
  emoji: json['emoji'] as String? ?? '🎓',
  description: json['description'] as String? ?? '',
  joinCode: json['joinCode'] as String? ?? '',
  isDiscoverable: json['isDiscoverable'] as bool? ?? true,
  memberCount: (json['memberCount'] as num?)?.toInt() ?? 0,
  createdAt: _dateFromJson(json['createdAt']),
);

Map<String, dynamic> _$StudyGroupToJson(_StudyGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'emoji': instance.emoji,
      'description': instance.description,
      'joinCode': instance.joinCode,
      'isDiscoverable': instance.isDiscoverable,
      'memberCount': instance.memberCount,
      'createdAt': _dateToJson(instance.createdAt),
    };
