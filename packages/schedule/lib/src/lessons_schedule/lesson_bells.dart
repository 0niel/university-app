import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule/schedule.dart';

part 'lesson_bells.freezed.dart';
part 'lesson_bells.g.dart';

@freezed
abstract class LessonBells with _$LessonBells {
  @Assert(
    'number == null || number > 0',
    'Lesson number must be greater than 0',
  )
  @Assert(
    'startTime < endTime',
    'Lesson start time must be less than lesson end time',
  )
  const factory LessonBells({
    @JsonKey(fromJson: _timeFromJson, toJson: _timeToJson)
    required TimeOfDay startTime,
    @JsonKey(fromJson: _timeFromJson, toJson: _timeToJson)
    required TimeOfDay endTime,
    int? number,
  }) = _LessonBells;

  const LessonBells._();

  factory LessonBells.fromJson(Map<String, dynamic> json) =>
      _$LessonBellsFromJson(json);

  @override
  String toString() => '$startTime-$endTime';
}

TimeOfDay _timeFromJson(String time) => .fromString(time);

String _timeToJson(TimeOfDay time) => time.toString();
