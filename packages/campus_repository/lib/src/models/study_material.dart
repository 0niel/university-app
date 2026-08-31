import 'package:campus_repository/src/models/json_converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'study_material.freezed.dart';
part 'study_material.g.dart';

@freezed
abstract class StudyMaterial with _$StudyMaterial {
  const factory StudyMaterial({
    @JsonKey(defaultValue: '') required String id,
    @JsonKey(defaultValue: '') required String title,
    @Default('') String subjectName,
    @Default('note') String materialType,
    @Default(0) int downloads,
    @Default(0) int likes,
    @Default(0) int price,
    @Default(0) int pages,
    @Default('') String authorName,
    @Default('') String fileName,
    @Default('') String mimeType,
    @Default(0) int fileSize,
    @Default(false) bool hasFile,
    @Default(false) bool isMine,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? createdAt,
  }) = _StudyMaterial;

  const StudyMaterial._();

  factory StudyMaterial.fromJson(Map<String, Object?> json) =>
      _$StudyMaterialFromJson(json);

  bool get isFree => price == 0;
}

@freezed
abstract class MaterialAuthor with _$MaterialAuthor {
  const factory MaterialAuthor({
    @JsonKey(defaultValue: '') required String name,
    @Default(0) int downloads,
    @Default(0) int materials,
  }) = _MaterialAuthor;

  factory MaterialAuthor.fromJson(Map<String, Object?> json) =>
      _$MaterialAuthorFromJson(json);
}
