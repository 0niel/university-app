// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamification_badge_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GamificationBadgeSummary _$GamificationBadgeSummaryFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_GamificationBadgeSummary', json, ($checkedConvert) {
  final val = _GamificationBadgeSummary(
    id: $checkedConvert('id', (v) => v as String),
    name: $checkedConvert('name', (v) => v as String),
    emoji: $checkedConvert('emoji', (v) => v as String),
    rarity: $checkedConvert('rarity', (v) => v as String? ?? 'common'),
  );
  return val;
});

Map<String, dynamic> _$GamificationBadgeSummaryToJson(
  _GamificationBadgeSummary instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'emoji': instance.emoji,
  'rarity': instance.rarity,
};
