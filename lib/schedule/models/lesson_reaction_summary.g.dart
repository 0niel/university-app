// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_reaction_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LessonReactionSummary _$LessonReactionSummaryFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_LessonReactionSummary', json, ($checkedConvert) {
  final val = _LessonReactionSummary(
    subjectName: $checkedConvert('subjectName', (v) => v as String),
    lessonDate: $checkedConvert(
      'lessonDate',
      (v) => DateTime.parse(v as String),
    ),
    lessonBells: $checkedConvert(
      'lessonBells',
      (v) => LessonBells.fromJson(v as Map<String, dynamic>),
    ),
    reactionCounts: $checkedConvert(
      'reactionCounts',
      (v) => v == null
          ? const ReactionCounts()
          : ReactionCounts.fromJson(v as Map<String, dynamic>),
    ),
    userReaction: $checkedConvert(
      'userReaction',
      (v) => $enumDecodeNullable(_$ReactionTypeEnumMap, v),
    ),
  );
  return val;
});

Map<String, dynamic> _$LessonReactionSummaryToJson(
  _LessonReactionSummary instance,
) => <String, dynamic>{
  'subjectName': instance.subjectName,
  'lessonDate': instance.lessonDate.toIso8601String(),
  'lessonBells': instance.lessonBells.toJson(),
  'reactionCounts': instance.reactionCounts.toJson(),
  'userReaction': _$ReactionTypeEnumMap[instance.userReaction],
};

const _$ReactionTypeEnumMap = {
  ReactionType.fire: 'fire',
  ReactionType.brain: 'brain',
  ReactionType.love: 'love',
  ReactionType.sad: 'sad',
  ReactionType.flushed: 'flushed',
  ReactionType.sick: 'sick',
  ReactionType.poo: 'poo',
  ReactionType.thinking: 'thinking',
  ReactionType.sleepy: 'sleepy',
  ReactionType.skull: 'skull',
  ReactionType.mindblown: 'mindblown',
  ReactionType.respect: 'respect',
};
