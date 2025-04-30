import 'package:dart_frog/dart_frog.dart';
import 'package:supabase/supabase.dart';
import 'package:university_app_server_api/src/supabase.dart';

/// Provides a [SupabaseClient] to the current [RequestContext].
Middleware supabaseProvider() {
  return (handler) {
    return (context) async {
      final supabaseManager = SupabaseClientManager.create();

      final token = context.request.headers['Authorization']?.split(' ').last;
      if (token != null) {
        await supabaseManager.client.auth.setSession(token);
      }

      final updatedContext = context.provide<SupabaseClient>(() => supabaseManager.client);
      return handler(updatedContext);
    };
  };
}
