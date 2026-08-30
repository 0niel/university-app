// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_group_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudyGroupMember _$StudyGroupMemberFromJson(Map<String, dynamic> json) =>
    _StudyGroupMember(
      userId: json['userId'] as String,
      fullName: json['fullName'] as String,
      handle: json['handle'] as String?,
      role: json['role'] as String? ?? 'member',
      isOwner: json['isOwner'] as bool? ?? false,
      isMe: json['isMe'] as bool? ?? false,
      isFriend: json['isFriend'] as bool? ?? false,
      friendshipStatus: json['friendshipStatus'] as String?,
    );

Map<String, dynamic> _$StudyGroupMemberToJson(_StudyGroupMember instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'fullName': instance.fullName,
      'handle': instance.handle,
      'role': instance.role,
      'isOwner': instance.isOwner,
      'isMe': instance.isMe,
      'isFriend': instance.isFriend,
      'friendshipStatus': instance.friendshipStatus,
    };
