import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:university_app_server_api/client.dart';

part 'schedule_comment.g.dart';

/// {@template schedule_comment}
/// Comment for lesson.
/// {@endtemplate}
@immutable
@JsonSerializable()
class ScheduleComment extends Equatable {
  /// {@macro schedule_comment}
  const ScheduleComment({
    required this.subjectName,
    required this.lessonDate,
    required this.lessonBells,
    required this.text,
  });

  /// {@macro from_json}
  factory ScheduleComment.fromJson(Map<String, dynamic> json) => _$ScheduleCommentFromJson(json);

  /// {@macro to_json}
  Map<String, dynamic> toJson() => _$ScheduleCommentToJson(this);

  /// Comment id.
  final String subjectName;

  /// Date when lesson is scheduled.
  final DateTime lessonDate;

  final LessonBells lessonBells;

  /// Comment text.
  final String text;

  ScheduleComment copyWith({
    String? subjectName,
    DateTime? lessonDate,
    LessonBells? lessonBells,
    String? text,
  }) {
    return ScheduleComment(
      subjectName: subjectName ?? this.subjectName,
      lessonDate: lessonDate ?? this.lessonDate,
      lessonBells: lessonBells ?? this.lessonBells,
      text: text ?? this.text,
    );
  }

  @override
  List<Object?> get props => [
        subjectName,
        lessonDate,
        lessonBells,
        text,
      ];
}
