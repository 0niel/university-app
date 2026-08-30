import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/schedule/models/custom_lesson_recurrence.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:uuid/uuid.dart';

part 'custom_lesson.freezed.dart';
part 'custom_lesson.g.dart';

@freezed
abstract class CustomLesson with _$CustomLesson {
  const factory CustomLesson({
    required String id,
    required String subject,
    required LessonType lessonType,
    required List<Teacher> teachers,
    required List<Classroom> classrooms,
    required LessonBells lessonBells,
    required CustomLessonRecurrence recurrence,
    int? color,
    int? reminderMinutes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CustomLesson;

  const CustomLesson._();

  factory CustomLesson.fromSchedulePart(
    LessonSchedulePart lesson, {
    String? id,
    DateTime? now,
  }) {
    final timestamp = now ?? DateTime.now();
    return CustomLesson(
      id: id ?? lesson.uid ?? const Uuid().v4(),
      subject: lesson.subject,
      lessonType: lesson.lessonType,
      teachers: lesson.teachers,
      classrooms: lesson.classrooms,
      lessonBells: lesson.lessonBells,
      recurrence: CustomLessonRecurrence.fromDates(lesson.dates),
      color: lesson.color,
      reminderMinutes: lesson.reminderMinutes,
      createdAt: timestamp,
      updatedAt: timestamp,
    );
  }

  factory CustomLesson.fromJson(Map<String, dynamic> json) =>
      _$CustomLessonFromJson(json);

  LessonSchedulePart toSchedulePart(DateTime reference) => .new(
    subject: subject,
    lessonType: lessonType,
    teachers: teachers,
    classrooms: classrooms,
    lessonBells: lessonBells,
    dates: recurrence.expand(reference),
    uid: id,
    color: color,
    reminderMinutes: reminderMinutes,
  );
}
