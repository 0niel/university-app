import 'package:dart_frog/dart_frog.dart';
import 'package:supabase/supabase.dart';
import 'package:university_app_server_api/api.dart';

/// Provides a [SplashVideoDataSource] to the request context.
Middleware splashVideoDataSourceProvider() {
  return provider<SplashVideoDataSource>(
    (context) => SupabaseSplashVideoDataSource(
      client: context.read<SupabaseClient>(),
    ),
  );
}
