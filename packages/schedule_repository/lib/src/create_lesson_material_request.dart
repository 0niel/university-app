import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule_repository/src/lesson_material_type.dart';

part 'create_lesson_material_request.freezed.dart';

@freezed
abstract class CreateLessonMaterialRequest with _$CreateLessonMaterialRequest {
  const factory CreateLessonMaterialRequest({
    required String subjectName,
    required DateTime lessonDate,
    required int lessonBellsNumber,
    required LessonMaterialType materialType,
    required String title,
    required String fileName,
    required List<int> bytes,
    required bool isPublic,
    required bool isAnonymous,
    String? lessonUid,
    String? mimeType,
  }) = _CreateLessonMaterialRequest;
}
