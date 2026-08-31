// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_reactions_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LessonReactionsState _$LessonReactionsStateFromJson(
  Map<String, dynamic> json,
) => _LessonReactionsState(
  summaries:
      (json['summaries'] as List<dynamic>?)
          ?.map(
            (e) => LessonReactionSummary.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$LessonReactionsStateToJson(
  _LessonReactionsState instance,
) => <String, dynamic>{
  'summaries': instance.summaries.map((e) => e.toJson()).toList(),
};
