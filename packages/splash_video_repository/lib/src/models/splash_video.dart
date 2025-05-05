/// {@template splash_video}
/// Model representing splash video information
/// {@endtemplate}
class SplashVideo {
  /// {@macro splash_video}
  const SplashVideo({
    required this.videoUrl,
    required this.lastUpdated,
    required this.endDate,
    required this.isEnabled,
  });

  /// URL to the splash video
  final String videoUrl;

  /// Last updated timestamp in ISO 8601 format
  final String lastUpdated;

  /// End date/time after which the video should no longer be shown (ISO 8601)
  final String endDate;

  /// Whether the splash video is enabled
  final bool isEnabled;
}
