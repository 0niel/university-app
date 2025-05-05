import 'package:splash_video_repository/splash_video_repository.dart';
import 'package:university_app_server_api/client.dart';

/// Adapter class to make ApiClient implement ApiClientInterface
class ApiClientAdapter implements ApiClientInterface {
  /// Creates a new instance of [ApiClientAdapter].
  const ApiClientAdapter(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<ApiSplashVideoResponse> getSplashVideo() async {
    final response = await _apiClient.getSplashVideo();

    // Convert the API response to our expected model
    return ApiSplashVideoResponse(
      videoUrl: response.videoUrl,
      lastUpdated: response.lastUpdated,
      endDate: response.endDate,
      isEnabled: response.isEnabled,
    );
  }
}
