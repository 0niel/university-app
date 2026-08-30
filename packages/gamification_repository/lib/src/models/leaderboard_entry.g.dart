// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeaderboardEntry _$LeaderboardEntryFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_LeaderboardEntry', json, ($checkedConvert) {
  final val = _LeaderboardEntry(
    userId: $checkedConvert('userId', (v) => v as String),
    xp: $checkedConvert('xp', (v) => (v as num).toInt()),
    displayName: $checkedConvert(
      'displayName',
      (v) => v as String? ?? 'Студент',
    ),
    level: $checkedConvert('level', (v) => (v as num?)?.toInt() ?? 1),
    streakDays: $checkedConvert('streakDays', (v) => (v as num?)?.toInt() ?? 0),
    isCurrentUser: $checkedConvert('isCurrentUser', (v) => v as bool? ?? false),
  );
  return val;
});

Map<String, dynamic> _$LeaderboardEntryToJson(_LeaderboardEntry instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'xp': instance.xp,
      'displayName': instance.displayName,
      'level': instance.level,
      'streakDays': instance.streakDays,
      'isCurrentUser': instance.isCurrentUser,
    };
