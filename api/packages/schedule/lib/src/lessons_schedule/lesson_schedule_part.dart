import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:schedule/schedule_parts.dart';
import 'package:schedule/src/dates_converter.dart';

part 'lesson_schedule_part.g.dart';

/// {@template lesson_schedule_part}
/// The part of a schedule which represents a academic lesson.
/// {@endtemplate}
@JsonSerializable()
class LessonSchedulePart with EquatableMixin implements SchedulePart {
  /// {@macro lesson_schedule_part}
  LessonSchedulePart({
    required this.subject,
    required this.lessonType,
    required this.teachers,
    required this.classroom,
    required this.lessonBells,
    required this.dates,
    this.type = LessonSchedulePart.identifier,
  });

  /// Lesson for online lessons.
  LessonSchedulePart.online({
    required this.subject,
    required String url,
    required this.lessonType,
    required this.teachers,
    required this.lessonBells,
    required this.dates,
    this.type = LessonSchedulePart.identifier,
  })  : classroom = Classroom.online(url: url),
        assert(url.startsWith('http'), 'Invalid URL');

  /// Converts a `Map<String, dynamic>` into a [LessonSchedulePart] instance.
  factory LessonSchedulePart.fromJson(Map<String, dynamic> json) =>
      _$LessonSchedulePartFromJson(json);

  /// The large post block type identifier.
  static const identifier = '__lesson_schedule__';

  @override
  final String type;

  /// Name of the subject.
  final String subject;

  /// The type of lesson.
  final LessonType lessonType;

  /// The teachers of the lesson. This is a list because there can be more than
  /// one teacher (for example, in a laboratory work).
  final List<Teacher> teachers;

  /// The classroom where the lesson will take place.
  final Classroom classroom;

  /// When the lesson starts, it ends, as well as the lesson number.
  final LessonBells lessonBells;

  /// Is the lesson online.
  bool get isOnline => classroom.isOnline;

  @override
  @DatesConverter()
  final List<DateTime> dates;

  @override
  Map<String, dynamic> toJson() => _$LessonSchedulePartToJson(this);

  @override
  List<Object?> get props => [
        type,
        subject,
        lessonType,
        teachers,
        classroom,
        lessonBells,
      ];
}
