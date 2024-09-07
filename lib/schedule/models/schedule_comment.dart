import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_comment.g.dart';

/// {@template schedule_comment}
/// Comment for schedules.
/// {@endtemplate}
@immutable
@JsonSerializable()
class ScheduleComment extends Equatable {
  /// {@macro schedule_comment}
  const ScheduleComment({
    required this.scheduleName,
    required this.text,
  });

  /// {@macro from_json}
  factory ScheduleComment.fromJson(Map<String, dynamic> json) => _$ScheduleCommentFromJson(json);

  /// {@macro to_json}
  Map<String, dynamic> toJson() => _$ScheduleCommentToJson(this);

  /// Group, classroom or teacher name.
  final String scheduleName;

  /// Comment text.
  final String text;

  ScheduleComment copyWith({
    String? scheduleName,
    String? text,
  }) {
    return ScheduleComment(
      scheduleName: scheduleName ?? this.scheduleName,
      text: text ?? this.text,
    );
  }

  @override
  List<Object?> get props => [
        scheduleName,
        text,
      ];
}
