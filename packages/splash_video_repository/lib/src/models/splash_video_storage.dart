/// {@template splash_video_storage}
/// Interface for splash video storage operations
/// {@endtemplate}
abstract class SplashVideoStorage {
  /// {@macro splash_video_storage}
  const SplashVideoStorage();

  /// Get the last shown date of the splash video
  Future<String?> getLastShownDate();

  /// Save the last shown date of the splash video
  Future<void> saveLastShownDate(String date);

  /// Get the path to the locally stored splash video
  Future<String?> getVideoPath();

  /// Save the path to the locally stored splash video
  Future<void> saveVideoPath(String path);
}
