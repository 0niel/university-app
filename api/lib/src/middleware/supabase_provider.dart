import 'package:dart_frog/dart_frog.dart';
import 'package:supabase/supabase.dart';
import 'package:university_app_server_api/src/supabase.dart';

/// Provides a [SupabaseClient] to the current [RequestContext].
Middleware supabaseProvider() {
  return (handler) {
    return (context) async {
      final supabaseManager = SupabaseClientManager.instance;

      final token = context.request.headers['Authorization']?.split(' ').last;
      final scoped = (token != null && token.isNotEmpty)
          ? supabaseManager.createScopedClient(accessToken: token)
          : supabaseManager.client;

      final updatedContext = context.provide<SupabaseClient>(() => scoped);
      return handler(updatedContext);
    };
  };
}
