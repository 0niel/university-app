import 'package:campus_repository/src/models/json_converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'teacher_profile.freezed.dart';
part 'teacher_profile.g.dart';

@Freezed(toJson: true)
abstract class TeacherProfile with _$TeacherProfile {
  const factory TeacherProfile({
    @JsonKey(defaultValue: '') required String teacherName,
    @Default(0) int reviewsCount,
    double? clarity,
    double? loyalty,
    double? usefulness,
    @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)
    @Default(<String>[])
    List<String> subjects,
    @JsonKey(fromJson: _reviewsFromJson, toJson: _reviewsToJson)
    @Default(<TeacherReview>[])
    List<TeacherReview> reviews,
  }) = _TeacherProfile;

  const TeacherProfile._();

  factory TeacherProfile.fromJson(Map<String, Object?> json) =>
      _$TeacherProfileFromJson(json);

  static const empty = TeacherProfile(teacherName: '');

  double? get overall {
    final values = [clarity, loyalty, usefulness].whereType<double>();
    if (values.isEmpty) return null;
    return values.reduce((sum, value) => sum + value) / values.length;
  }
}

@freezed
abstract class TeacherReview with _$TeacherReview {
  const factory TeacherReview({
    @JsonKey(defaultValue: '') required String id,
    @Default(0) int clarity,
    @Default(0) int loyalty,
    @Default(0) int usefulness,
    @Default('') String body,
    @Default('') String authorName,
    @Default(false) bool isMine,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? createdAt,
  }) = _TeacherReview;

  const TeacherReview._();

  factory TeacherReview.fromJson(Map<String, Object?> json) =>
      _$TeacherReviewFromJson(json);

  double get average => (clarity + loyalty + usefulness) / 3;
}

List<TeacherReview> _reviewsFromJson(Object? value) => value is List
    ? value
          .whereType<Map<Object?, Object?>>()
          .map((review) => TeacherReview.fromJson(review.cast()))
          .toList()
    : const [];

List<Map<String, Object?>> _reviewsToJson(List<TeacherReview> value) =>
    value.map((review) => review.toJson()).toList();
