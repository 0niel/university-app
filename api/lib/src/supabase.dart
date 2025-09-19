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
      // (Windows Cyrillic fix)
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
  static SupabaseClientManager? _instance;

  /// Returns a singleton instance of [SupabaseClientManager].
  static SupabaseClientManager get instance {
    if (_instance == null) {
      final manager = SupabaseClientManager();
      try {
        manager._client = SupabaseClient(
          _appConfig.supabaseUrl,
          _appConfig.supabaseAnonKey,
          httpClient: _sharedHttpClient,
        );
      } catch (e) {
        _logger.e('Failed to create Supabase client', error: e);
        rethrow;
      }
      _instance = manager;
    }
    return _instance!;
  }

  // Reuse a single HTTP client across requests.
  // The wrapper sanitizes headers and the underlying client keeps a keep-alive
  // connection pool which is safe to share for the lifetime of the process.
  static final http.Client _sharedHttpClient =
      _HttpClientWrapper(http.Client());

  /// Creates a per-request [SupabaseClient] that reuses the shared HTTP
  /// connection pool. Optionally sets an access token for auth-scoped calls.
  SupabaseClient createScopedClient({String? accessToken}) {
    final client = SupabaseClient(
      _appConfig.supabaseUrl,
      _appConfig.supabaseAnonKey,
      httpClient: _sharedHttpClient,
    );
    if (accessToken != null && accessToken.isNotEmpty) {
      // ignore: discarded_futures
      client.auth.setSession(accessToken);
    }
    return client;
  }

  /// Returns the [SupabaseClient] for operations.
  SupabaseClient get client {
    if (_client == null) {
      throw StateError('The Supabase connection is not established.');
    }
    return _client!;
  }
}
