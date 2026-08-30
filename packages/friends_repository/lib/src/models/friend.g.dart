// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Friend _$FriendFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_Friend', json, ($checkedConvert) {
      final val = _Friend(
        friendshipId: $checkedConvert('friendshipId', (v) => v as String),
        userId: $checkedConvert('userId', (v) => v as String),
        fullName: $checkedConvert('fullName', (v) => v as String? ?? 'Студент'),
        handle: $checkedConvert('handle', (v) => v as String?),
        group: $checkedConvert('group', (v) => v as String?),
        latitude: $checkedConvert('latitude', (v) => (v as num?)?.toDouble()),
        longitude: $checkedConvert('longitude', (v) => (v as num?)?.toDouble()),
        battery: $checkedConvert('battery', (v) => (v as num?)?.toInt()),
        mood: $checkedConvert('mood', (v) => v as String? ?? ''),
        isGhost: $checkedConvert('isGhost', (v) => v as bool? ?? false),
        locationUpdatedAt: $checkedConvert(
          'locationUpdatedAt',
          (v) => optionalDateTimeFromJson(v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$FriendToJson(_Friend instance) => <String, dynamic>{
  'friendshipId': instance.friendshipId,
  'userId': instance.userId,
  'fullName': instance.fullName,
  'handle': instance.handle,
  'group': instance.group,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'battery': instance.battery,
  'mood': instance.mood,
  'isGhost': instance.isGhost,
  'locationUpdatedAt': optionalDateTimeToJson(instance.locationUpdatedAt),
};
