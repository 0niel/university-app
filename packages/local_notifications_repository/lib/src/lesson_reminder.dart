import 'package:freezed_annotation/freezed_annotation.dart';

part 'lesson_reminder.freezed.dart';

/// A single local reminder to fire before a lesson starts.
@freezed
abstract class LessonReminder with _$LessonReminder {
  /// Creates a notification reminder for one lesson.
  const factory LessonReminder({
    required int id,
    required String title,
    required String body,
    required DateTime when,
  }) = _LessonReminder;
}
