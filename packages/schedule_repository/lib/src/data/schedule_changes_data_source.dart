import 'package:schedule_repository/src/schedule_change.dart';
import 'package:schedule_repository/src/schedule_target_type.dart';
import 'package:schedule_repository/src/util/supabase_json.dart';
import 'package:supabase/supabase.dart';

/// Reads the per-target schedule change feed maintained server-side by
/// `core.refresh_schedule_change_log()`.
class ScheduleChangesDataSource {
  const ScheduleChangesDataSource({
    required SupabaseClient supabaseClient,
    required this._organizationId,
  }) : _supabase = supabaseClient;

  final SupabaseClient _supabase;
  final String _organizationId;

  Future<List<ScheduleChange>> getScheduleChanges({
    required ScheduleTargetType targetType,
    required String target,
    int limit = 60,
  }) async {
    final response = await _supabase.rpc<Object?>(
      'get_schedule_changes',
      params: {
        'p_organization_id': _organizationId,
        'p_target_type': targetType.wireValue,
        'p_target': target,
        'p_limit': limit,
      },
    );
    return SupabaseJson.mapRows(response, ScheduleChange.fromJson);
  }
}
