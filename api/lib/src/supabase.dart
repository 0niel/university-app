import 'package:supabase/supabase.dart';
import 'package:university_app_server_api/config.dart';
import 'package:university_app_server_api/src/logger.dart';

final _appConfig = Config();
final _logger = getLogger('SupabaseClient');

/// {@template supabase_client}
/// A Supabase client.
/// {@endtemplate}
class SupabaseClientManager {
  /// Creates a new instance of [SupabaseClientManager].
  SupabaseClientManager();

  SupabaseClient? _client;

  /// Creates and returns a new [SupabaseClientManager] instance.
  static SupabaseClientManager create() {
    final manager = SupabaseClientManager();
    try {
      manager._client = SupabaseClient(
        _appConfig.supabaseUrl,
        _appConfig.supabaseKey,
      );
    } catch (e) {
      _logger.e('Failed to connect to create Supabase client', error: e);
      rethrow;
    }
    return manager;
  }

  /// Returns the [SupabaseClient] for operations.
  SupabaseClient get client {
    if (_client == null) {
      throw StateError('The Supabase connection is not established.');
    }
    return _client!;
  }
}
