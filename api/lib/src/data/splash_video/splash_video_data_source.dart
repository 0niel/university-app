import 'package:university_app_server_api/src/models/splash_video_response.dart';

/// {@template splash_video_data_source}
/// Interface for splash video data source.
/// {@endtemplate}
abstract class SplashVideoDataSource {
  /// {@macro splash_video_data_source}
  const SplashVideoDataSource();

  /// Retrieves splash video information
  Future<SplashVideoResponse> getSplashVideo();
}
