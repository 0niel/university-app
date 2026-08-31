// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggested_friend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SuggestedFriend _$SuggestedFriendFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_SuggestedFriend', json, ($checkedConvert) {
      final val = _SuggestedFriend(
        userId: $checkedConvert('userId', (v) => v as String),
        fullName: $checkedConvert('fullName', (v) => v as String? ?? 'Студент'),
        handle: $checkedConvert('handle', (v) => v as String?),
        group: $checkedConvert('group', (v) => v as String?),
        mutualCount: $checkedConvert(
          'mutualCount',
          (v) => (v as num?)?.toInt() ?? 0,
        ),
      );
      return val;
    });

Map<String, dynamic> _$SuggestedFriendToJson(_SuggestedFriend instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'fullName': instance.fullName,
      'handle': instance.handle,
      'group': instance.group,
      'mutualCount': instance.mutualCount,
    };
