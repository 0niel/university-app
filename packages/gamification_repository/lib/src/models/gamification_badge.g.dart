// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamification_badge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GamificationBadge _$GamificationBadgeFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_GamificationBadge', json, ($checkedConvert) {
      final val = _GamificationBadge(
        id: $checkedConvert('id', (v) => v as String),
        category: $checkedConvert('category', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        description: $checkedConvert('description', (v) => v as String),
        emoji: $checkedConvert('emoji', (v) => v as String),
        rarity: $checkedConvert('rarity', (v) => v as String? ?? 'common'),
        xpReward: $checkedConvert('xpReward', (v) => (v as num?)?.toInt() ?? 0),
        shurikenReward: $checkedConvert(
          'shurikenReward',
          (v) => (v as num?)?.toInt() ?? 0,
        ),
        isEarned: $checkedConvert('isEarned', (v) => v as bool? ?? false),
        progress: $checkedConvert(
          'progress',
          (v) => (v as num?)?.toDouble() ?? 0,
        ),
        earnedAt: $checkedConvert('earnedAt', (v) => dateTimeFromJson(v)),
      );
      return val;
    });

Map<String, dynamic> _$GamificationBadgeToJson(_GamificationBadge instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'name': instance.name,
      'description': instance.description,
      'emoji': instance.emoji,
      'rarity': instance.rarity,
      'xpReward': instance.xpReward,
      'shurikenReward': instance.shurikenReward,
      'isEarned': instance.isEarned,
      'progress': instance.progress,
      'earnedAt': dateTimeToJson(instance.earnedAt),
    };
