// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_reaction_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LessonReactionResponse _$LessonReactionResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_LessonReactionResponse', json, ($checkedConvert) {
  final val = _LessonReactionResponse(
    counts: $checkedConvert('counts', (v) => Map<String, int>.from(v as Map)),
    userReaction: $checkedConvert('userReaction', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$LessonReactionResponseToJson(
  _LessonReactionResponse instance,
) => <String, dynamic>{
  'counts': instance.counts,
  'userReaction': instance.userReaction,
};
