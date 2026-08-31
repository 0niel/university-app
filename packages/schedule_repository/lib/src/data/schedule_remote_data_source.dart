import 'package:schedule/schedule.dart' as domain;
import 'package:schedule_repository/src/models/schedule_target_row.dart';
import 'package:schedule_repository/src/schedule_target_type.dart';
import 'package:schedule_repository/src/util/supabase_json.dart';
import 'package:supabase/supabase.dart';

class ScheduleRemoteDataSource {
  const ScheduleRemoteDataSource({
    required SupabaseClient supabaseClient,
    required this.organizationId,
  }) : _supabase = supabaseClient;

  final SupabaseClient _supabase;
  final String organizationId;

  Future<List<domain.SchedulePart>> getSchedule({
    required ScheduleTargetType targetType,
    required String target,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    final response = await _supabase.rpc<Object?>(
      'get_schedule_for_entity',
      params: {
        'p_entity_type': targetType.wireValue,
        'p_entity': target,
        'p_date_from': dateFrom == null
            ? null
            : SupabaseJson.dateParam(dateFrom),
        'p_date_to': dateTo == null ? null : SupabaseJson.dateParam(dateTo),
        'p_organization_id': organizationId,
      },
    );

    return _scheduleParts(response);
  }

  Future<List<ScheduleTargetRow>> searchTargets({
    required ScheduleTargetType targetType,
    required String query,
    int limit = 20,
  }) async {
    final response = await _supabase.rpc<Object?>(
      'search_schedule_targets',
      params: {
        'p_target_type': targetType.wireValue,
        'p_query': query,
        'p_organization_id': organizationId,
        'p_limit': limit,
      },
    );

    return SupabaseJson.mapRows(response, ScheduleTargetRow.fromJson);
  }

  List<domain.SchedulePart> _scheduleParts(Object? response) {
    return SupabaseJson.mapRows(response, domain.SchedulePart.fromJson);
  }
}
