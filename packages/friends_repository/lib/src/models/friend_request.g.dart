// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FriendRequest _$FriendRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_FriendRequest', json, ($checkedConvert) {
      final val = _FriendRequest(
        friendshipId: $checkedConvert('friendshipId', (v) => v as String),
        userId: $checkedConvert('userId', (v) => v as String),
        fullName: $checkedConvert('fullName', (v) => v as String? ?? 'Студент'),
        handle: $checkedConvert('handle', (v) => v as String?),
        group: $checkedConvert('group', (v) => v as String?),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => optionalDateTimeFromJson(v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$FriendRequestToJson(_FriendRequest instance) =>
    <String, dynamic>{
      'friendshipId': instance.friendshipId,
      'userId': instance.userId,
      'fullName': instance.fullName,
      'handle': instance.handle,
      'group': instance.group,
      'createdAt': optionalDateTimeToJson(instance.createdAt),
    };
