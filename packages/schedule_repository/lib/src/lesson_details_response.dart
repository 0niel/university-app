import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule_repository/src/lesson_material.dart';
import 'package:schedule_repository/src/lesson_reaction_response.dart';
import 'package:schedule_repository/src/lesson_review.dart';

part 'lesson_details_response.freezed.dart';

@freezed
abstract class LessonDetailsResponse with _$LessonDetailsResponse {
  const factory LessonDetailsResponse({
    required LessonReactionResponse reactions,
    required List<LessonMaterial> materials,
    required List<LessonReview> reviews,
  }) = _LessonDetailsResponse;
}
