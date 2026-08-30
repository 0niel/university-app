// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LessonReaction _$LessonReactionFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_LessonReaction', json, ($checkedConvert) {
      final val = _LessonReaction(
        subjectName: $checkedConvert('subjectName', (v) => v as String),
        lessonDate: $checkedConvert(
          'lessonDate',
          (v) => DateTime.parse(v as String),
        ),
        lessonBells: $checkedConvert(
          'lessonBells',
          (v) => LessonBells.fromJson(v as Map<String, dynamic>),
        ),
        reactionType: $checkedConvert(
          'reactionType',
          (v) => $enumDecode(_$ReactionTypeEnumMap, v),
        ),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$LessonReactionToJson(_LessonReaction instance) =>
    <String, dynamic>{
      'subjectName': instance.subjectName,
      'lessonDate': instance.lessonDate.toIso8601String(),
      'lessonBells': instance.lessonBells.toJson(),
      'reactionType': _$ReactionTypeEnumMap[instance.reactionType]!,
      'createdAt': instance.createdAt.toIso8601String(),
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
