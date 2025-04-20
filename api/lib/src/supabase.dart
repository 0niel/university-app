import 'dart:async';

import 'package:supabase/supabase.dart';
import 'package:university_app_server_api/config.dart';
import 'package:university_app_server_api/src/logger.dart';

final _appConfig = Config();
final _logger = getLogger('SupabaseClient');

/// {@template supabase_client}
/// A Supabase client.
/// {@endtemplate}
class SupabaseClientManager {
  SupabaseClientManager._internal();

  static SupabaseClientManager? _instance;
  SupabaseClient? _client;

  /// Returns the [SupabaseClientManager] instance.
  static Future<SupabaseClientManager> get instance async {
    _instance ??= SupabaseClientManager._internal();
    await _instance!._ensureConnected();
    return _instance!;
  }

  Future<void> _ensureConnected() async {
    if (_client == null) {
      try {
        _logger.i('Connecting to Supabase... ${_appConfig.supabaseUrl}');
        _client = SupabaseClient(
          _appConfig.supabaseUrl,
          _appConfig.supabaseKey,
        );
        // Test connection
        await _client!.from('health_check').select().limit(1);
        _logger.i('Connected to Supabase successfully');
      } catch (e) {
        _logger.e('Failed to connect to Supabase', error: e);
        // Create a fallback connection with proper error handling
        rethrow;
      }
    }
  }

  /// Closes the connection to the Supabase server.
  Future<void> close() async {
    _logger.i('Closing Supabase connection');
    _client = null;
  }

  /// Returns the [SupabaseClient] for operations.
  SupabaseClient get client {
    if (_client == null) {
      throw StateError('The Supabase connection is not established.');
    }
    return _client!;
  }
}
