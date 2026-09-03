// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_space_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupSpaceMember _$GroupSpaceMemberFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_GroupSpaceMember', json, ($checkedConvert) {
      final val = _GroupSpaceMember(
        userId: $checkedConvert('userId', (v) => v as String? ?? ''),
        fullName: $checkedConvert('fullName', (v) => v as String? ?? ''),
        handle: $checkedConvert('handle', (v) => v as String?),
        role: $checkedConvert('role', (v) => v as String? ?? 'member'),
        isOwner: $checkedConvert('isOwner', (v) => v as bool? ?? false),
        isMe: $checkedConvert('isMe', (v) => v as bool? ?? false),
      );
      return val;
    });

Map<String, dynamic> _$GroupSpaceMemberToJson(_GroupSpaceMember instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'fullName': instance.fullName,
      'handle': instance.handle,
      'role': instance.role,
      'isOwner': instance.isOwner,
      'isMe': instance.isMe,
    };
