import 'package:schedule_repository/src/user_activity.dart';
import 'package:schedule_repository/src/util/supabase_json.dart';
import 'package:supabase/supabase.dart';

/// Reads and writes the current user's non-class activities through Supabase
/// RPC (owner-scoped by RLS).
class UserActivitiesDataSource {
  const UserActivitiesDataSource({
    required SupabaseClient supabaseClient,
    required this._organizationId,
  }) : _supabase = supabaseClient;

  final SupabaseClient _supabase;
  final String _organizationId;

  Future<List<UserActivity>> getUserActivities({
    required DateTime from,
    required DateTime to,
  }) async {
    final response = await _supabase.rpc<Object?>(
      'get_user_activities',
      params: {
        'p_organization_id': _organizationId,
        'p_from': SupabaseJson.dateParam(from),
        'p_to': SupabaseJson.dateParam(to),
      },
    );
    return SupabaseJson.mapRows(response, UserActivity.fromJson);
  }

  Future<UserActivity> upsertUserActivity(
    UpsertUserActivityRequest request,
  ) async {
    final response = await _supabase.rpc<Object?>(
      'upsert_user_activity',
      params: {
        'p_organization_id': _organizationId,
        'p_id': request.id,
        'p_activity_type': request.type.wireValue,
        'p_title': request.title,
        'p_place': request.place,
        'p_subtitle': request.subtitle,
        'p_lesson_uid': request.lessonUid,
        'p_starts_at': request.startsAt.toUtc().toIso8601String(),
        'p_ends_at': request.endsAt?.toUtc().toIso8601String(),
      },
    );
    final rows = SupabaseJson.mapRows(response, UserActivity.fromJson);
    if (rows case [final activity, ...]) return activity;
    throw StateError('Empty user activity response');
  }

  Future<void> deleteUserActivity(String id) async {
    await _supabase.rpc<Object?>(
      'delete_user_activity',
      params: {'p_id': id},
    );
  }
}
