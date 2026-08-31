// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamification_quest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GamificationQuest _$GamificationQuestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_GamificationQuest', json, ($checkedConvert) {
      final val = _GamificationQuest(
        id: $checkedConvert('id', (v) => v as String),
        period: $checkedConvert('period', (v) => v as String),
        emoji: $checkedConvert('emoji', (v) => v as String),
        title: $checkedConvert('title', (v) => v as String),
        target: $checkedConvert('target', (v) => (v as num).toInt()),
        xpReward: $checkedConvert('xpReward', (v) => (v as num).toInt()),
        progress: $checkedConvert('progress', (v) => (v as num?)?.toInt() ?? 0),
        isCompleted: $checkedConvert('isCompleted', (v) => v as bool? ?? false),
        completedAt: $checkedConvert('completedAt', (v) => dateTimeFromJson(v)),
      );
      return val;
    });

Map<String, dynamic> _$GamificationQuestToJson(_GamificationQuest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'period': instance.period,
      'emoji': instance.emoji,
      'title': instance.title,
      'target': instance.target,
      'xpReward': instance.xpReward,
      'progress': instance.progress,
      'isCompleted': instance.isCompleted,
      'completedAt': dateTimeToJson(instance.completedAt),
    };
