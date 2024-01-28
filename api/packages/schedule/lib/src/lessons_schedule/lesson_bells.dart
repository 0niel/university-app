import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:schedule/schedule.dart';

part 'lesson_bells.g.dart';

/// {@template LessonBells}
/// A lesson bell is a time interval in which a lesson takes place.
/// {@endtemplate}
@JsonSerializable()
@immutable
class LessonBells extends Equatable {
  /// {@macro LessonBells}
  const LessonBells({
    required this.number,
    required this.startTime,
    required this.endTime,
  })  : assert(number > 0, 'Lesson number must be greater than 0'),
        assert(
          startTime < endTime,
          'Lesson start time must be less than lesson end time',
        );

  /// Converts a `Map<String, dynamic>` into a [LessonBells] instance.
  factory LessonBells.fromJson(Map<String, dynamic> json) => _$LessonBellsFromJson(json);

  /// Lesson number.
  final int number;

  /// Lesson start time. This is [TimeOfDay] with only the time part.
  @JsonKey(fromJson: _timeFromJson, toJson: _timeToJson)
  final TimeOfDay startTime;

  /// Lesson end time. This is [TimeOfDay] with only the time part.
  @JsonKey(fromJson: _timeFromJson, toJson: _timeToJson)
  final TimeOfDay endTime;

  static TimeOfDay _timeFromJson(String time) {
    return TimeOfDay.fromString(time);
  }

  static String _timeToJson(TimeOfDay time) {
    return time.toString();
  }

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$LessonBellsToJson(this);

  @override
  List<Object?> get props => [number, startTime, endTime];
}
