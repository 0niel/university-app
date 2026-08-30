// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_study_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MyStudyGroup _$MyStudyGroupFromJson(Map<String, dynamic> json) =>
    _MyStudyGroup(
      hasGroup: json['hasGroup'] as bool? ?? false,
      isOwner: json['isOwner'] as bool? ?? false,
      group: _groupFromJson(json['group']),
      members: json['members'] == null
          ? const <StudyGroupMember>[]
          : _membersFromJson(json['members']),
      incomingInvites: json['incomingInvites'] == null
          ? const <StudyGroupInvite>[]
          : _invitesFromJson(json['incomingInvites']),
      pendingRequests: json['pendingRequests'] == null
          ? const <StudyGroupJoinRequest>[]
          : _requestsFromJson(json['pendingRequests']),
    );

Map<String, dynamic> _$MyStudyGroupToJson(_MyStudyGroup instance) =>
    <String, dynamic>{
      'hasGroup': instance.hasGroup,
      'isOwner': instance.isOwner,
      'group': _groupToJson(instance.group),
      'members': _membersToJson(instance.members),
      'incomingInvites': _invitesToJson(instance.incomingInvites),
      'pendingRequests': _requestsToJson(instance.pendingRequests),
    };
