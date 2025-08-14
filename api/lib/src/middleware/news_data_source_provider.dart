import 'package:dart_frog/dart_frog.dart';
import 'package:supabase/supabase.dart';
import 'package:university_app_server_api/api.dart';

/// Provides a [NewsDataSource] to the current [RequestContext].
Middleware newsDataSourceProvider() {
  return provider<NewsDataSource>((context) {
    final supabaseClient = context.read<SupabaseClient>();
    return CombinedNewsDataSource(
      supabaseClient: supabaseClient,
    );
  });
}
