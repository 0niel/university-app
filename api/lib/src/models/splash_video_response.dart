import 'package:json_annotation/json_annotation.dart';

part 'splash_video_response.g.dart';

/// {@template splash_video_response}
/// Response model for splash video data
/// {@endtemplate}
@JsonSerializable()
class SplashVideoResponse {
  /// {@macro splash_video_response}
  const SplashVideoResponse({
    required this.videoUrl,
    required this.lastUpdated,
    required this.endDate,
    required this.isEnabled,
  });

  /// Creates a SplashVideoResponse from a JSON object
  factory SplashVideoResponse.fromJson(Map<String, dynamic> json) => _$SplashVideoResponseFromJson(json);

  /// URL to the splash video
  final String videoUrl;

  /// Last updated timestamp in ISO 8601 format
  final String lastUpdated;

  /// End date/time after which the video should no longer be shown (ISO 8601)
  final String endDate;

  /// Whether the splash video is enabled
  final bool isEnabled;

  /// Converts this object to a JSON object
  Map<String, dynamic> toJson() => _$SplashVideoResponseToJson(this);
}
