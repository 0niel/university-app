import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:university_app_server_api/client.dart';
import 'package:uuid/uuid.dart';

part 'custom_schedule.freezed.dart';
part 'custom_schedule.g.dart';

@freezed
class CustomSchedule with _$CustomSchedule {
  const factory CustomSchedule({
    required String id,
    required String name,
    required List<LessonSchedulePart> lessons,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CustomSchedule;

  factory CustomSchedule.create(String name, {String? description}) {
    final uuid = const Uuid().v4();
    final now = DateTime.now();
    return CustomSchedule(id: uuid, name: name, description: description, lessons: [], createdAt: now, updatedAt: now);
  }

  factory CustomSchedule.fromJson(Map<String, dynamic> json) => _$CustomScheduleFromJson(json);
}
