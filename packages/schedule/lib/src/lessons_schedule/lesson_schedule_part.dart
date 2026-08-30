import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule/schedule.dart';
import 'package:schedule/src/dates_converter.dart';

part 'lesson_schedule_part.freezed.dart';
part 'lesson_schedule_part.g.dart';

/// A normalized academic lesson from any schedule source.
@Freezed()
abstract class LessonSchedulePart
    with _$LessonSchedulePart
    implements SchedulePart {
  /// Creates a lesson schedule part.
  const factory LessonSchedulePart({
    required String subject,
    required LessonType lessonType,
    required List<Teacher> teachers,
    required List<Classroom> classrooms,
    required LessonBells lessonBells,
    @DatesConverter() required List<DateTime> dates,
    List<String>? groups,
    List<Group>? groupEntities,
    String? uid,
    int? color,
    int? reminderMinutes,
    @Default(LessonSchedulePart.identifier) String type,
  }) = _LessonSchedulePart;

  const LessonSchedulePart._();

  /// Creates a lesson whose classroom is an online URL.
  factory LessonSchedulePart.online({
    required String subject,
    required LessonType lessonType,
    required List<Teacher> teachers,
    required LessonBells lessonBells,
    @DatesConverter() required List<DateTime> dates,
    required List<String>? groups,
    String? url,
    List<Group>? groupEntities,
    String? uid,
    int? color,
    int? reminderMinutes,
    String type = LessonSchedulePart.identifier,
  }) => LessonSchedulePart(
    subject: subject,
    lessonType: lessonType,
    teachers: teachers,
    classrooms: [Classroom.online(url: url)],
    lessonBells: lessonBells,
    dates: dates,
    groups: groups,
    groupEntities: groupEntities,
    uid: uid,
    color: color,
    reminderMinutes: reminderMinutes,
    type: type,
  );

  /// Decodes a lesson schedule part.
  factory LessonSchedulePart.fromJson(Map<String, dynamic> json) =>
      _$LessonSchedulePartFromJson(json);

  /// Polymorphic schedule-part discriminator.
  static const identifier = '__lesson_schedule__';

  /// Whether every classroom is online.
  bool get isOnline => classrooms.every((classroom) => classroom.isOnline);

  /// Whether the lesson represents an assessment or consultation.
  bool get isSessionLesson =>
      lessonType == .exam ||
      lessonType == .credit ||
      lessonType == .courseWork ||
      lessonType == .courseProject ||
      lessonType == .consultation;
}
