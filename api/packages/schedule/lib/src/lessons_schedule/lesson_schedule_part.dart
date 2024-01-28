import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:schedule/schedule.dart';
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
    required this.classrooms,
    required this.lessonBells,
    required this.dates,
    this.groups,
    this.type = LessonSchedulePart.identifier,
  });

  /// Lesson for online lessons.
  LessonSchedulePart.online({
    required this.subject,
    required this.lessonType,
    required this.teachers,
    required this.lessonBells,
    required this.dates,
    required this.groups,
    String? url,
    this.type = LessonSchedulePart.identifier,
  }) : classrooms = [
          Classroom.online(url: url),
        ];

  /// Converts a `Map<String, dynamic>` into a [LessonSchedulePart] instance.
  factory LessonSchedulePart.fromJson(Map<String, dynamic> json) => _$LessonSchedulePartFromJson(json);

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

  /// The classrooms where the lesson takes place.
  final List<Classroom> classrooms;

  /// When the lesson starts, it ends, as well as the lesson number.
  final LessonBells lessonBells;

  /// Academic groups that attend the lesson.
  ///
  /// May be `null` if the lesson displays for specific group or List if the
  /// lesson displays for classroom, teacher (for example, in a
  /// lectures teacher has many groups).
  final List<String>? groups;

  /// Is the lesson online.
  bool get isOnline => classrooms.every((classroom) => classroom.isOnline);

  @override
  @DatesConverter()
  final List<DateTime> dates;

  @override
  Map<String, dynamic> toJson() => _$LessonSchedulePartToJson(this);

  /// Creates a copy of this [LessonSchedulePart] but with the given fields
  /// replaced with the new values.
  LessonSchedulePart copyWith({
    String? subject,
    LessonType? lessonType,
    List<Teacher>? teachers,
    List<Classroom>? classrooms,
    LessonBells? lessonBells,
    List<DateTime>? dates,
    List<String>? groups,
    String? type,
  }) {
    return LessonSchedulePart(
      subject: subject ?? this.subject,
      lessonType: lessonType ?? this.lessonType,
      teachers: teachers ?? this.teachers,
      classrooms: classrooms ?? this.classrooms,
      lessonBells: lessonBells ?? this.lessonBells,
      dates: dates ?? this.dates,
      groups: groups ?? this.groups,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [
        type,
        subject,
        lessonType,
        teachers,
        classrooms,
        lessonBells,
        dates,
        groups,
      ];
}
