// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_comments_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LessonCommentsState _$LessonCommentsStateFromJson(Map<String, dynamic> json) =>
    _LessonCommentsState(
      comments:
          (json['comments'] as List<dynamic>?)
              ?.map((e) => LessonComment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      scheduleComments:
          (json['scheduleComments'] as List<dynamic>?)
              ?.map((e) => ScheduleComment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$LessonCommentsStateToJson(
  _LessonCommentsState instance,
) => <String, dynamic>{
  'comments': instance.comments.map((e) => e.toJson()).toList(),
  'scheduleComments': instance.scheduleComments.map((e) => e.toJson()).toList(),
};
