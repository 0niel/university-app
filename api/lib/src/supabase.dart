import 'package:http/http.dart' as http;
import 'package:supabase/supabase.dart';
import 'package:university_app_server_api/config.dart';
import 'package:university_app_server_api/src/logger.dart';

final _appConfig = Config.instance;
final _logger = getLogger('SupabaseClient');

/// HTTP client wrapper to fix encoding issues with Windows Cyrillic characters
class _HttpClientWrapper extends http.BaseClient {
  _HttpClientWrapper(this._inner);
  final http.Client _inner;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final sanitizedHeaders = <String, String>{};

    for (final entry in request.headers.entries) {
      final key = entry.key;
      final value = entry.value;

      // Sanitize header values that contain non-ASCII characters
      if (_containsNonAscii(value)) {
        sanitizedHeaders[key] = _sanitizeHeaderValue(value);
      } else {
        sanitizedHeaders[key] = value;
      }
    }

    // Update request headers
    request.headers.clear();
    request.headers.addAll(sanitizedHeaders);

    return _inner.send(request);
  }

  bool _containsNonAscii(String value) {
    return value.runes.any((rune) => rune > 127);
  }

  String _sanitizeHeaderValue(String value) {
    // Replace non-ASCII characters with ASCII equivalent or remove them
    return value
        .replaceAll(RegExp(r'[^\x00-\x7F]'), '') // Remove non-ASCII chars
        .replaceAll(RegExp(r'\s+'), ' ') // Normalize whitespace
        .trim();
  }

  @override
  void close() {
    _inner.close();
  }
}

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
        _appConfig.supabaseAnonKey,
        httpClient: _createHttpClient(),
      );
    } catch (e) {
      _logger.e('Failed to connect to create Supabase client', error: e);
      rethrow;
    }
    return manager;
  }

  /// Creates an HTTP client with proper headers to avoid encoding issues
  static http.Client _createHttpClient() {
    final client = http.Client();
    return _HttpClientWrapper(client);
  }

  /// Returns the [SupabaseClient] for operations.
  SupabaseClient get client {
    if (_client == null) {
      throw StateError('The Supabase connection is not established.');
    }
    return _client!;
  }
}
