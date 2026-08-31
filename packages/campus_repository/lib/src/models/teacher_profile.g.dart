// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeacherProfile _$TeacherProfileFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_TeacherProfile', json, ($checkedConvert) {
      final val = _TeacherProfile(
        teacherName: $checkedConvert('teacherName', (v) => v as String? ?? ''),
        reviewsCount: $checkedConvert(
          'reviewsCount',
          (v) => (v as num?)?.toInt() ?? 0,
        ),
        clarity: $checkedConvert('clarity', (v) => (v as num?)?.toDouble()),
        loyalty: $checkedConvert('loyalty', (v) => (v as num?)?.toDouble()),
        usefulness: $checkedConvert(
          'usefulness',
          (v) => (v as num?)?.toDouble(),
        ),
        subjects: $checkedConvert(
          'subjects',
          (v) => v == null ? const <String>[] : stringListFromJson(v),
        ),
        reviews: $checkedConvert(
          'reviews',
          (v) => v == null ? const <TeacherReview>[] : _reviewsFromJson(v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$TeacherProfileToJson(_TeacherProfile instance) =>
    <String, dynamic>{
      'teacherName': instance.teacherName,
      'reviewsCount': instance.reviewsCount,
      'clarity': instance.clarity,
      'loyalty': instance.loyalty,
      'usefulness': instance.usefulness,
      'subjects': stringListToJson(instance.subjects),
      'reviews': _reviewsToJson(instance.reviews),
    };

_TeacherReview _$TeacherReviewFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_TeacherReview', json, ($checkedConvert) {
      final val = _TeacherReview(
        id: $checkedConvert('id', (v) => v as String? ?? ''),
        clarity: $checkedConvert('clarity', (v) => (v as num?)?.toInt() ?? 0),
        loyalty: $checkedConvert('loyalty', (v) => (v as num?)?.toInt() ?? 0),
        usefulness: $checkedConvert(
          'usefulness',
          (v) => (v as num?)?.toInt() ?? 0,
        ),
        body: $checkedConvert('body', (v) => v as String? ?? ''),
        authorName: $checkedConvert('authorName', (v) => v as String? ?? ''),
        isMine: $checkedConvert('isMine', (v) => v as bool? ?? false),
        createdAt: $checkedConvert('createdAt', (v) => dateTimeFromJson(v)),
      );
      return val;
    });

Map<String, dynamic> _$TeacherReviewToJson(_TeacherReview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clarity': instance.clarity,
      'loyalty': instance.loyalty,
      'usefulness': instance.usefulness,
      'body': instance.body,
      'authorName': instance.authorName,
      'isMine': instance.isMine,
      'createdAt': dateTimeToJson(instance.createdAt),
    };
