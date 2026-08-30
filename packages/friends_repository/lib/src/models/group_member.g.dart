// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupMember _$GroupMemberFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_GroupMember', json, ($checkedConvert) {
      final val = _GroupMember(
        userId: $checkedConvert('userId', (v) => v as String),
        fullName: $checkedConvert('fullName', (v) => v as String? ?? 'Студент'),
        handle: $checkedConvert('handle', (v) => v as String?),
        isMe: $checkedConvert('isMe', (v) => v as bool? ?? false),
        isFriend: $checkedConvert('isFriend', (v) => v as bool? ?? false),
        friendshipStatus: $checkedConvert(
          'friendshipStatus',
          (v) => v as String?,
        ),
      );
      return val;
    });

Map<String, dynamic> _$GroupMemberToJson(_GroupMember instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'fullName': instance.fullName,
      'handle': instance.handle,
      'isMe': instance.isMe,
      'isFriend': instance.isFriend,
      'friendshipStatus': instance.friendshipStatus,
    };
