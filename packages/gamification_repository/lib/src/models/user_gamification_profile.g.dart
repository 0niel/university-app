// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_gamification_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserGamificationProfile _$UserGamificationProfileFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_UserGamificationProfile', json, ($checkedConvert) {
  final val = _UserGamificationProfile(
    userId: $checkedConvert('userId', (v) => v as String? ?? ''),
    xp: $checkedConvert('xp', (v) => (v as num?)?.toInt() ?? 0),
    level: $checkedConvert('level', (v) => (v as num?)?.toInt() ?? 1),
    shurikens: $checkedConvert('shurikens', (v) => (v as num?)?.toInt() ?? 0),
    streakDays: $checkedConvert('streakDays', (v) => (v as num?)?.toInt() ?? 0),
    longestStreak: $checkedConvert(
      'longestStreak',
      (v) => (v as num?)?.toInt() ?? 0,
    ),
    lastActiveDate: $checkedConvert(
      'lastActiveDate',
      (v) => dateTimeFromJson(v),
    ),
    recentBadge: $checkedConvert(
      'recentBadge',
      (v) => v == null
          ? null
          : GamificationBadgeSummary.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$UserGamificationProfileToJson(
  _UserGamificationProfile instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'xp': instance.xp,
  'level': instance.level,
  'shurikens': instance.shurikens,
  'streakDays': instance.streakDays,
  'longestStreak': instance.longestStreak,
  'lastActiveDate': dateTimeToJson(instance.lastActiveDate),
  'recentBadge': instance.recentBadge?.toJson(),
};
