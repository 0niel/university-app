import 'package:supabase/supabase.dart';
import 'package:university_app_server_api/src/data/splash_video/splash_video_data_source.dart';
import 'package:university_app_server_api/src/models/splash_video_response.dart';

/// {@template supabase_splash_video_data_source}
/// Supabase implementation of the [SplashVideoDataSource]
/// {@endtemplate}
class SupabaseSplashVideoDataSource extends SplashVideoDataSource {
  /// {@macro supabase_splash_video_data_source}
  const SupabaseSplashVideoDataSource({
    required SupabaseClient client,
  }) : _client = client;

  final SupabaseClient _client;

  /// The table name in Supabase
  static const _tableName = 'splash_videos';

  @override
  Future<SplashVideoResponse> getSplashVideo() async {
    try {
      final response = await _client.from(_tableName).select().order('created_at', ascending: false).limit(1).single();

      return SplashVideoResponse(
        videoUrl: response['video_url'] as String,
        lastUpdated: response['created_at'] as String,
        endDate: response['end_date'] as String,
        isEnabled: response['is_enabled'] as bool,
      );
    } catch (e) {
      throw Exception('Failed to get splash video: $e');
    }
  }
}
