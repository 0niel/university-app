import 'package:dart_frog/dart_frog.dart';
import 'package:supabase/supabase.dart';
import 'package:university_app_server_api/src/data/lost_and_found/lost_and_found_data_source.dart';
import 'package:university_app_server_api/src/data/lost_and_found/supabase_lost_and_found_data_source.dart';

/// Provides a [LostAndFoundDataSource] to the current [RequestContext].
Middleware lostAndFoundDataSourceProvider() {
  return provider<LostAndFoundDataSource>((context) {
    final supabaseClient = context.read<SupabaseClient>();
    return SupabaseLostAndFoundDataSource(supabaseClient: supabaseClient);
  });
}
