import 'dart:typed_data';

import 'package:schedule_repository/src/data/lesson_reactions_data_source.dart';
import 'package:schedule_repository/src/lesson_details.dart';
import 'package:schedule_repository/src/util/supabase_json.dart';
import 'package:supabase/supabase.dart';

class LessonMaterialsDataSource {
  const LessonMaterialsDataSource({
    required SupabaseClient supabaseClient,
    required this._organizationId,
  }) : _supabase = supabaseClient;

  final SupabaseClient _supabase;
  final String _organizationId;

  static const _bucket = 'lesson-materials';

  Future<LessonDetailsResponse> getLessonDetails(LessonReactionKey key) async {
    final reactions = _supabase.rpc<Object?>(
      'get_lesson_reactions',
      params: key.toParams(),
    );
    final materials = _supabase.rpc<Object?>(
      'get_lesson_materials',
      params: {'p_organization_id': _organizationId, ...key.toParams()},
    );
    final reviews = _supabase.rpc<Object?>(
      'get_lesson_reviews',
      params: {'p_organization_id': _organizationId, ...key.toParams()},
    );

    return LessonDetailsResponse(
      reactions: reactionResponseFromJson(await reactions),
      materials: SupabaseJson.mapRows(await materials, LessonMaterial.fromJson),
      reviews: SupabaseJson.mapRows(await reviews, LessonReview.fromJson),
    );
  }

  Future<List<LessonReview>> upsertLessonReview(
    UpsertLessonReviewRequest request,
  ) async {
    final response = await _supabase.rpc<Object?>(
      'upsert_lesson_review',
      params: {
        'p_organization_id': _organizationId,
        'p_subject_name': request.subjectName,
        'p_lesson_date': SupabaseJson.dateParam(request.lessonDate),
        'p_lesson_bells_number': request.lessonBellsNumber,
        'p_lesson_uid': request.lessonUid,
        'p_body': request.body,
        'p_rating': request.rating,
        'p_is_anonymous': request.isAnonymous,
      },
    );
    return SupabaseJson.mapRows(response, LessonReview.fromJson);
  }

  Future<LessonMaterial> uploadLessonMaterial(
    CreateLessonMaterialRequest request,
  ) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null || userId.isEmpty) {
      throw StateError('Unauthorized');
    }

    final filePath = _materialStoragePath(
      userId: userId,
      lessonDate: request.lessonDate,
      lessonBellsNumber: request.lessonBellsNumber,
      fileName: request.fileName,
    );

    await _supabase.storage
        .from(_bucket)
        .uploadBinary(
          filePath,
          Uint8List.fromList(request.bytes),
          fileOptions: FileOptions(
            contentType: request.mimeType ?? 'application/octet-stream',
          ),
        );

    final response = await _supabase.rpc<Object?>(
      'create_lesson_material',
      params: {
        'p_organization_id': _organizationId,
        'p_subject_name': request.subjectName,
        'p_lesson_date': SupabaseJson.dateParam(request.lessonDate),
        'p_lesson_bells_number': request.lessonBellsNumber,
        'p_lesson_uid': request.lessonUid,
        'p_material_type': request.materialType.wireValue,
        'p_title': request.title,
        'p_file_name': request.fileName,
        'p_file_path': filePath,
        'p_mime_type': request.mimeType,
        'p_file_size': request.bytes.length,
        'p_is_public': request.isPublic,
        'p_is_anonymous': request.isAnonymous,
      },
    );

    if (response is! Map) throw StateError('Empty material response');
    return LessonMaterial.fromJson(SupabaseJson.stringKeyMap(response));
  }

  Future<String> createSignedUrl(LessonMaterial material) {
    return _supabase.storage
        .from(_bucket)
        .createSignedUrl(material.filePath, 60 * 10);
  }

  String _materialStoragePath({
    required String userId,
    required DateTime lessonDate,
    required int lessonBellsNumber,
    required String fileName,
  }) {
    final safeName = fileName
        .replaceAll(RegExp('[^A-Za-z0-9а-яА-ЯёЁ._-]+'), '_')
        .replaceAll(RegExp('_+'), '_');
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    return '$userId/${SupabaseJson.dateParam(lessonDate)}/$lessonBellsNumber/'
        '${timestamp}_${safeName.isEmpty ? 'material' : safeName}';
  }
}
