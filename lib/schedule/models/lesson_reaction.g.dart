// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonReaction _$LessonReactionFromJson(Map<String, dynamic> json) => LessonReaction(
  subjectName: json['subjectName'] as String,
  lessonDate: DateTime.parse(json['lessonDate'] as String),
  lessonBells: LessonBells.fromJson(json['lessonBells'] as Map<String, dynamic>),
  reactionType: $enumDecode(_$ReactionTypeEnumMap, json['reactionType']),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$LessonReactionToJson(LessonReaction instance) => <String, dynamic>{
  'subjectName': instance.subjectName,
  'lessonDate': instance.lessonDate.toIso8601String(),
  'lessonBells': instance.lessonBells.toJson(),
  'reactionType': _$ReactionTypeEnumMap[instance.reactionType]!,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$ReactionTypeEnumMap = {
  ReactionType.love: 'love',
  ReactionType.sad: 'sad',
  ReactionType.flushed: 'flushed',
  ReactionType.sick: 'sick',
  ReactionType.poo: 'poo',
  ReactionType.sleepy: 'sleepy',
};

LessonReactionSummary _$LessonReactionSummaryFromJson(Map<String, dynamic> json) => LessonReactionSummary(
  subjectName: json['subjectName'] as String,
  lessonDate: DateTime.parse(json['lessonDate'] as String),
  lessonBells: LessonBells.fromJson(json['lessonBells'] as Map<String, dynamic>),
  reactionCounts: (json['reactionCounts'] as Map<String, dynamic>).map(
    (k, e) => MapEntry($enumDecode(_$ReactionTypeEnumMap, k), (e as num).toInt()),
  ),
  userReaction: $enumDecodeNullable(_$ReactionTypeEnumMap, json['userReaction']),
);

Map<String, dynamic> _$LessonReactionSummaryToJson(LessonReactionSummary instance) => <String, dynamic>{
  'subjectName': instance.subjectName,
  'lessonDate': instance.lessonDate.toIso8601String(),
  'lessonBells': instance.lessonBells.toJson(),
  'reactionCounts': instance.reactionCounts.map((k, e) => MapEntry(_$ReactionTypeEnumMap[k]!, e)),
  'userReaction': _$ReactionTypeEnumMap[instance.userReaction],
};
