import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule_repository/src/util/json_parser.dart';

part 'lesson_review.freezed.dart';
part 'lesson_review.g.dart';

@freezed
abstract class LessonReview with _$LessonReview {
  const factory LessonReview({
    required String id,
    required String body,
    required bool isAnonymous,
    required int likeCount,
    required String authorName,
    required DateTime createdAt,
    int? rating,
  }) = _LessonReview;

  factory LessonReview.fromJson(Map<String, dynamic> json) =>
      _$LessonReviewFromJson({
        'id': json['id'].toString(),
        'body': json['body'].toString(),
        'rating': JsonParser.nullableInteger(json['rating']),
        'isAnonymous': json['isAnonymous'] as bool? ?? false,
        'likeCount': JsonParser.integer(json['likeCount']),
        'authorName': json['authorName']?.toString() ?? 'Студент',
        'createdAt': JsonParser.localDateTime(json['createdAt']),
      });
}
