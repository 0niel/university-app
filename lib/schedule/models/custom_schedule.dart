import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/schedule/models/custom_lesson.dart';
import 'package:uuid/uuid.dart';

part 'custom_schedule.freezed.dart';
part 'custom_schedule.g.dart';

@freezed
abstract class CustomSchedule with _$CustomSchedule {
  const factory CustomSchedule({
    required String id,
    required String name,
    required List<CustomLesson> lessons,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CustomSchedule;

  const CustomSchedule._();

  factory CustomSchedule.create(
    String name, {
    String? description,
    DateTime? now,
  }) {
    final uuid = const Uuid().v4();
    final timestamp = now ?? DateTime.now();
    return CustomSchedule(
      id: uuid,
      name: name,
      description: description,
      lessons: [],
      createdAt: timestamp,
      updatedAt: timestamp,
    );
  }

  factory CustomSchedule.fromJson(Map<String, dynamic> json) =>
      _$CustomScheduleFromJson(json);

  DateTime? get lastModifiedAt => [
    updatedAt,
    ...lessons.map((lesson) => lesson.updatedAt),
  ].nonNulls.maxOrNull;
}
