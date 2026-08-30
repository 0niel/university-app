import 'package:schedule_repository/src/deadline.dart';
import 'package:schedule_repository/src/deadline_priority.dart';
import 'package:schedule_repository/src/deadline_source.dart';
import 'package:schedule_repository/src/util/supabase_json.dart';
import 'package:supabase/supabase.dart';

/// Reads and writes deadlines through Supabase RPC. Personal rows are
/// owner-scoped by RLS; group/prof rows are shared within the academic group.
class DeadlinesDataSource {
  const DeadlinesDataSource({
    required SupabaseClient supabaseClient,
    required this._organizationId,
  }) : _supabase = supabaseClient;

  final SupabaseClient _supabase;
  final String _organizationId;

  Future<List<Deadline>> getDeadlines() async {
    final response = await _supabase.rpc<Object?>(
      'get_deadlines',
      params: {'p_organization_id': _organizationId},
    );
    return SupabaseJson.mapRows(response, Deadline.fromJson);
  }

  Future<void> createDeadline({
    required String title,
    required String subjectName,
    required DateTime dueAt,
    DeadlineSource source = DeadlineSource.me,
    DeadlinePriority priority = DeadlinePriority.medium,
    bool remind = true,
  }) async {
    await _supabase.rpc<Object?>(
      'create_deadline',
      params: {
        'p_organization_id': _organizationId,
        'p_title': title,
        'p_subject_name': subjectName,
        'p_due_at': dueAt.toUtc().toIso8601String(),
        'p_source': source.wireValue,
        'p_priority': priority.wireValue,
        'p_remind': remind,
      },
    );
  }

  Future<void> setDeadlineState({
    required String id,
    int? progress,
    bool? done,
  }) async {
    await _supabase.rpc<Object?>(
      'set_deadline_state',
      params: {'p_id': id, 'p_progress': progress, 'p_done': done},
    );
  }

  Future<void> deleteDeadline(String id) async {
    await _supabase.rpc<Object?>('delete_deadline', params: {'p_id': id});
  }

  /// Schedules a server-side push reminder (delivered by pg_cron via FCM).
  Future<void> createReminder({
    required DateTime fireAt,
    required String title,
    String body = '',
    String route = '',
  }) async {
    await _supabase.rpc<Object?>(
      'create_reminder',
      params: {
        'p_fire_at': fireAt.toUtc().toIso8601String(),
        'p_title': title,
        'p_body': body,
        'p_route': route,
      },
    );
  }
}
