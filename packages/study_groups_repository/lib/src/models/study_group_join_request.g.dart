// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_group_join_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudyGroupJoinRequest _$StudyGroupJoinRequestFromJson(
  Map<String, dynamic> json,
) => _StudyGroupJoinRequest(
  id: json['id'] as String,
  userId: json['userId'] as String,
  fullName: json['fullName'] as String,
  handle: json['handle'] as String?,
  createdAt: _dateFromJson(json['createdAt']),
);

Map<String, dynamic> _$StudyGroupJoinRequestToJson(
  _StudyGroupJoinRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'fullName': instance.fullName,
  'handle': instance.handle,
  'createdAt': _dateToJson(instance.createdAt),
};
