import 'package:freezed_annotation/freezed_annotation.dart';

part 'upsert_lesson_review_request.freezed.dart';

@freezed
abstract class UpsertLessonReviewRequest with _$UpsertLessonReviewRequest {
  const factory UpsertLessonReviewRequest({
    required String subjectName,
    required DateTime lessonDate,
    required int lessonBellsNumber,
    required String body,
    required bool isAnonymous,
    String? lessonUid,
    int? rating,
  }) = _UpsertLessonReviewRequest;
}
