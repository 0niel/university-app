// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_location_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FriendLocationUpdate _$FriendLocationUpdateFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  '_FriendLocationUpdate',
  json,
  ($checkedConvert) {
    final val = _FriendLocationUpdate(
      userId: $checkedConvert('user_id', (v) => v as String),
      latitude: $checkedConvert('latitude', (v) => (v as num).toDouble()),
      longitude: $checkedConvert('longitude', (v) => (v as num).toDouble()),
      battery: $checkedConvert('battery', (v) => (v as num?)?.toInt()),
      mood: $checkedConvert('mood', (v) => v as String? ?? ''),
      isGhost: $checkedConvert('is_ghost', (v) => v as bool? ?? false),
      updatedAt: $checkedConvert(
        'updated_at',
        (v) => optionalDateTimeFromJson(v),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'userId': 'user_id',
    'isGhost': 'is_ghost',
    'updatedAt': 'updated_at',
  },
);

Map<String, dynamic> _$FriendLocationUpdateToJson(
  _FriendLocationUpdate instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'battery': instance.battery,
  'mood': instance.mood,
  'is_ghost': instance.isGhost,
  'updated_at': optionalDateTimeToJson(instance.updatedAt),
};
