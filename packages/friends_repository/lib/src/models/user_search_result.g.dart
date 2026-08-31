// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserSearchResult _$UserSearchResultFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_UserSearchResult', json, ($checkedConvert) {
      final val = _UserSearchResult(
        userId: $checkedConvert('userId', (v) => v as String),
        fullName: $checkedConvert('fullName', (v) => v as String? ?? 'Студент'),
        handle: $checkedConvert('handle', (v) => v as String?),
        group: $checkedConvert('group', (v) => v as String?),
        friendshipId: $checkedConvert('friendshipId', (v) => v as String?),
        friendshipStatus: $checkedConvert(
          'friendshipStatus',
          (v) => v as String?,
        ),
        isIncoming: $checkedConvert('isIncoming', (v) => v as bool? ?? false),
      );
      return val;
    });

Map<String, dynamic> _$UserSearchResultToJson(_UserSearchResult instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'fullName': instance.fullName,
      'handle': instance.handle,
      'group': instance.group,
      'friendshipId': instance.friendshipId,
      'friendshipStatus': instance.friendshipStatus,
      'isIncoming': instance.isIncoming,
    };
