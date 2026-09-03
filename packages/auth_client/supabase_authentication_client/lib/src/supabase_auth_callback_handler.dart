import 'package:supabase_flutter/supabase_flutter.dart';

enum SupabaseAuthCallbackResult { ignored, guestPreserved, authenticated }

class SupabaseAuthCallbackHandler {
  factory SupabaseAuthCallbackHandler.forClient(GoTrueClient auth) =>
      _instances[auth] ??= SupabaseAuthCallbackHandler._(auth);

  SupabaseAuthCallbackHandler._(this._auth);

  static final _instances = Expando<SupabaseAuthCallbackHandler>();

  final GoTrueClient _auth;
  Future<void> _pending = Future<void>.value();
  Uri? _lastHandled;

  Future<SupabaseAuthCallbackResult> handle(Uri uri) => _serialize(() async {
    final fragment = Uri.splitQueryString(uri.fragment);
    final isCallback =
        uri.queryParameters.containsKey('code') ||
        fragment.containsKey('access_token') ||
        fragment.containsKey('error_description') ||
        uri.queryParameters.containsKey('error_description');
    if (!isCallback) return SupabaseAuthCallbackResult.ignored;
    if (_auth.currentUser?.isAnonymous ?? false) {
      return SupabaseAuthCallbackResult.guestPreserved;
    }
    if (_lastHandled == uri) return SupabaseAuthCallbackResult.ignored;
    await _auth.getSessionFromUrl(uri);
    _lastHandled = uri;
    return SupabaseAuthCallbackResult.authenticated;
  });

  Future<void> signInAnonymously() => _serialize(() async {
    if (_auth.currentSession != null) return;
    await _auth.signInAnonymously();
  });

  Future<T> _serialize<T>(Future<T> Function() operation) {
    final result = _pending.then((_) => operation());
    _pending = result.then<void>(
      (_) {},
      onError: (Object error, StackTrace stackTrace) {},
    );
    return result;
  }
}
