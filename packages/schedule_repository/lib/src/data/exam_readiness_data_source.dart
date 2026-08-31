import 'package:schedule_repository/src/exam_readiness.dart';
import 'package:schedule_repository/src/util/supabase_json.dart';
import 'package:supabase/supabase.dart';

/// Reads and writes the current user's exam readiness through Supabase RPC
/// (owner-scoped by RLS).
class ExamReadinessDataSource {
  const ExamReadinessDataSource(this._supabase, this._organizationId);

  final SupabaseClient _supabase;
  final String _organizationId;

  Future<List<ExamReadiness>> getExamReadiness() async {
    final response = await _supabase.rpc<Object?>(
      'get_exam_readiness',
      params: {'p_organization_id': _organizationId},
    );
    return SupabaseJson.mapRows(response, ExamReadiness.fromJson);
  }

  Future<void> setExamReadiness({
    required String subjectName,
    required int readiness,
  }) async {
    await _supabase.rpc<Object?>(
      'set_exam_readiness',
      params: {
        'p_organization_id': _organizationId,
        'p_subject_name': subjectName,
        'p_readiness': readiness.clamp(0, 100),
      },
    );
  }
}
