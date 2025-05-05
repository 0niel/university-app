import 'package:http/http.dart' as http;
import 'models/models.dart';
import 'splash_video_repository.dart';

/// {@template api_splash_video_repository}
/// Implementation of [SplashVideoRepository] that fetches video data from API
/// {@endtemplate}
class ApiSplashVideoRepository extends SplashVideoRepositoryImpl {
  /// {@macro api_splash_video_repository}
  ApiSplashVideoRepository({
    required ApiClientInterface apiClient,
    required SplashVideoStorage storage,
    http.Client? httpClient,
  })  : _apiClient = apiClient,
        super(storage: storage, httpClient: httpClient);

  final ApiClientInterface _apiClient;

  @override
  Future<SplashVideo?> getSplashVideo() async {
    try {
      // Try to get video details from the API
      final response = await _apiClient.getSplashVideo();

      // First check if the video is enabled at all
      if (!response.isEnabled) {
        return null;
      }

      // Save the response data to storage
      await splashVideoStorage.saveLastShownDate(response.lastUpdated);

      // Check if the video should be shown (based on end date and other criteria)
      final videoStatus = await checkVideoStatus(
        videoUrl: response.videoUrl,
        endDate: response.endDate,
      );

      if (videoStatus is VideoStatusReady) {
        return SplashVideo(
          videoUrl: videoStatus.videoPath,
          lastUpdated: response.lastUpdated,
          endDate: response.endDate,
          isEnabled: response.isEnabled,
        );
      }

      return null;
    } catch (e) {
      // If API fails, try to get data from local storage
      return super.getSplashVideo();
    }
  }
}

/// Interface for the API client
abstract class ApiClientInterface {
  /// Gets splash video data from the API
  Future<ApiSplashVideoResponse> getSplashVideo();
}

/// API response for splash video
class ApiSplashVideoResponse {
  /// {@macro api_splash_video_response}
  const ApiSplashVideoResponse({
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
