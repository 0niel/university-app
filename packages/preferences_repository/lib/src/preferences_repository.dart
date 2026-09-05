import 'package:preferences_repository/src/data/remote_preferences_data_source.dart';
import 'package:preferences_repository/src/models/user_preference_entry.dart';
import 'package:preferences_repository/src/preferences_failure.dart';
import 'package:supabase/supabase.dart';

/// {@template preferences_repository}
/// Remote per-user key/value preferences stored in Supabase, used to back up
/// and restore feature settings across devices and reinstalls.
/// {@endtemplate}
class PreferencesRepository {
  /// {@macro preferences_repository}
  factory PreferencesRepository({required SupabaseClient supabaseClient}) =>
      PreferencesRepository._(
        supabaseClient.auth,
        RemotePreferencesDataSource(supabaseClient: supabaseClient),
      );

  /// Test seam that lets unit tests inject a fake data source.
  factory PreferencesRepository.fromDataSources({
    required GoTrueClient auth,
    required RemotePreferencesDataSource remote,
  }) => PreferencesRepository._(auth, remote);

  const PreferencesRepository._(this._auth, this._remote);

  final GoTrueClient _auth;
  final RemotePreferencesDataSource _remote;

  /// Whether preferences can be synced for the current session.
  bool get hasAuthenticatedUser => _auth.currentUser != null;

  String? get currentUserId => _auth.currentUser?.id;

  Stream<String?> get userIdChanges =>
      _auth.onAuthStateChange.map((state) => state.session?.user.id).distinct();

  /// Loads every stored preference of the current user.
  Future<List<UserPreferenceEntry>> getAll() {
    return _guard(_remote.getAll, GetPreferencesFailure.new);
  }

  /// Loads a single preference without fetching unrelated keys.
  Future<UserPreferenceEntry?> get(String key) {
    return _guard(() => _remote.get(key), GetPreferencesFailure.new);
  }

  /// Stores [value] without a revision precondition.
  Future<void> set(String key, Map<String, dynamic> value) {
    return _guard(() async {
      await _remote.set(key, value);
    }, SetPreferenceFailure.new);
  }

  /// Stores [value] only when [expectedRevision] is still current.
  Future<int> setVersioned(
    String key,
    Map<String, dynamic> value, {
    required int expectedRevision,
  }) async {
    try {
      return await _remote.set(key, value, expectedRevision: expectedRevision);
    } on PreferenceRevisionConflictException catch (error, stackTrace) {
      Error.throwWithStackTrace(PreferenceConflictFailure(error), stackTrace);
    } on Object catch (error, stackTrace) {
      Error.throwWithStackTrace(SetPreferenceFailure(error), stackTrace);
    }
  }

  /// Removes the stored preference [key].
  Future<void> remove(String key) {
    return _guard(() => _remote.remove(key), DeletePreferenceFailure.new);
  }

  Future<T> _guard<T>(
    Future<T> Function() action,
    PreferencesFailure Function(Object error) wrapError,
  ) async {
    try {
      return await action();
    } on Object catch (error, stackTrace) {
      Error.throwWithStackTrace(wrapError(error), stackTrace);
    }
  }
}
