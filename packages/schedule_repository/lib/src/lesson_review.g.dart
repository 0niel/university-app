// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LessonReview _$LessonReviewFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_LessonReview', json, ($checkedConvert) {
      final val = _LessonReview(
        id: $checkedConvert('id', (v) => v as String),
        body: $checkedConvert('body', (v) => v as String),
        isAnonymous: $checkedConvert('isAnonymous', (v) => v as bool),
        likeCount: $checkedConvert('likeCount', (v) => (v as num).toInt()),
        authorName: $checkedConvert('authorName', (v) => v as String),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
        rating: $checkedConvert('rating', (v) => (v as num?)?.toInt()),
      );
      return val;
    });

Map<String, dynamic> _$LessonReviewToJson(_LessonReview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'body': instance.body,
      'isAnonymous': instance.isAnonymous,
      'likeCount': instance.likeCount,
      'authorName': instance.authorName,
      'createdAt': instance.createdAt.toIso8601String(),
      'rating': instance.rating,
    };
