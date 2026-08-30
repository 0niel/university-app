// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_group_invite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudyGroupInvite _$StudyGroupInviteFromJson(Map<String, dynamic> json) =>
    _StudyGroupInvite(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      groupName: json['groupName'] as String,
      groupEmoji: json['groupEmoji'] as String? ?? '🎓',
      memberCount: (json['memberCount'] as num?)?.toInt() ?? 0,
      invitedByName: json['invitedByName'] as String? ?? '',
    );

Map<String, dynamic> _$StudyGroupInviteToJson(_StudyGroupInvite instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupId': instance.groupId,
      'groupName': instance.groupName,
      'groupEmoji': instance.groupEmoji,
      'memberCount': instance.memberCount,
      'invitedByName': instance.invitedByName,
    };
