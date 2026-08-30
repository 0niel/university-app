import 'package:preferences_repository/src/models/user_preference_entry.dart';
import 'package:preferences_repository/src/preferences_failure.dart';
import 'package:supabase/supabase.dart';

/// Executes owner-scoped preference RPCs.
class RemotePreferencesDataSource {
  /// Creates a data source backed by [supabaseClient].
  const RemotePreferencesDataSource({required SupabaseClient supabaseClient})
    : _supabase = supabaseClient;

  final SupabaseClient _supabase;

  /// Returns every preference of the authenticated user.
  Future<List<UserPreferenceEntry>> getAll() async {
    final response = await _supabase.rpc<Object?>('get_user_preferences');
    if (response is! List) {
      throw const PreferencesResponseException('Expected a preference list');
    }
    return response.map(_decodeEntry).toList();
  }

  /// Returns [key], or null when it has not been stored.
  Future<UserPreferenceEntry?> get(String key) async {
    final response = await _supabase.rpc<Object?>(
      'get_user_preference',
      params: {'p_key': key},
    );
    return response == null ? null : _decodeEntry(response);
  }

  /// Stores [value] and returns its new server revision.
  Future<int> set(
    String key,
    Map<String, dynamic> value, {
    int? expectedRevision,
  }) async {
    try {
      final response = await _supabase.rpc<Object?>(
        'set_user_preference',
        params: {
          'p_key': key,
          'p_value': value,
          'p_expected_revision': expectedRevision,
        },
      );
      if (response is num) return response.toInt();
      throw const PreferencesResponseException('Expected a revision number');
    } on PostgrestException catch (error, stackTrace) {
      if (error.code == 'PT409') {
        Error.throwWithStackTrace(
          const PreferenceRevisionConflictException(),
          stackTrace,
        );
      }
      rethrow;
    }
  }

  /// Removes [key] for the authenticated user.
  Future<void> remove(String key) async {
    await _supabase.rpc<Object?>(
      'delete_user_preference',
      params: {'p_key': key},
    );
  }

  UserPreferenceEntry _decodeEntry(Object? response) {
    if (response is! Map) {
      throw const PreferencesResponseException('Expected a preference object');
    }
    return UserPreferenceEntry.fromJson(
      response.map((key, value) => MapEntry(key.toString(), value)),
    );
  }
}
