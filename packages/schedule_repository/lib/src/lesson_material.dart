import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule_repository/src/lesson_material_type.dart';
import 'package:schedule_repository/src/util/json_parser.dart';

part 'lesson_material.freezed.dart';
part 'lesson_material.g.dart';

@freezed
abstract class LessonMaterial with _$LessonMaterial {
  const factory LessonMaterial({
    required String id,
    required LessonMaterialType type,
    required String title,
    required String fileName,
    required String filePath,
    required int fileSize,
    required bool isPublic,
    required bool isAnonymous,
    required int downloadCount,
    required int likeCount,
    required String authorName,
    required DateTime createdAt,
    String? mimeType,
    String? previewPath,
    String? batchId,
    int? width,
    int? height,
    int? durationSeconds,
    @Default(false) bool isLiked,
  }) = _LessonMaterial;

  factory LessonMaterial.fromJson(Map<String, dynamic> json) =>
      _$LessonMaterialFromJson({
        'id': json['id'].toString(),
        'type': LessonMaterialType.fromWireValue(
          json['type'].toString(),
        ).wireValue,
        'title': json['title'].toString(),
        'fileName': json['fileName'].toString(),
        'filePath': json['filePath'].toString(),
        'mimeType': json['mimeType'] as String?,
        'fileSize': JsonParser.integer(json['fileSize']),
        'isPublic': json['isPublic'] as bool? ?? true,
        'isAnonymous': json['isAnonymous'] as bool? ?? false,
        'downloadCount': JsonParser.integer(json['downloadCount']),
        'likeCount': JsonParser.integer(json['likeCount']),
        'authorName': json['authorName']?.toString() ?? 'Студент',
        'createdAt': JsonParser.localDateTime(json['createdAt']),
        'previewPath': json['previewPath'] as String?,
        'batchId': json['batchId'] as String?,
        'width': JsonParser.nullableInteger(json['width']),
        'height': JsonParser.nullableInteger(json['height']),
        'durationSeconds': JsonParser.nullableInteger(json['durationSeconds']),
        'isLiked': json['isLiked'] as bool? ?? false,
      });
}
