part of 'splash_video_repository.dart';

/// Storage keys for the [SplashVideoStorage].
abstract class SplashVideoStorageKeys {
  /// The last shown date of the splash video.
  static const lastShownDate = '__splash_video_last_shown_key__';

  /// The local path to the splash video file.
  static const videoPath = '__splash_video_path_key__';
}

/// {@template splash_video_storage}
/// Interface for storing and retrieving splash video data
/// {@endtemplate}
abstract class SplashVideoStorage {
  /// {@macro splash_video_storage}
  const SplashVideoStorage();

  /// Gets the last shown date of the splash video
  Future<String?> getLastShownDate();

  /// Gets the path to the splash video
  Future<String?> getVideoPath();

  /// Saves the last shown date of the splash video
  Future<void> saveLastShownDate(String date);

  /// Saves the path to the splash video
  Future<void> saveVideoPath(String path);
}

/// {@template splash_video_storage}
/// Storage for the [SplashVideoRepository].
/// {@endtemplate}
class SplashVideoStorageImpl implements SplashVideoStorage {
  /// {@macro splash_video_storage}
  const SplashVideoStorageImpl({required Storage storage}) : _storage = storage;

  final Storage _storage;

  /// Get the last shown date of the splash video
  @override
  Future<String?> getLastShownDate() async {
    return _storage.read(key: SplashVideoStorageKeys.lastShownDate);
  }

  /// Save the last shown date of the splash video
  @override
  Future<void> saveLastShownDate(String date) => _storage.write(key: SplashVideoStorageKeys.lastShownDate, value: date);

  /// Get the path to the locally stored splash video
  @override
  Future<String?> getVideoPath() async {
    return _storage.read(key: SplashVideoStorageKeys.videoPath);
  }

  /// Save the path to the locally stored splash video
  @override
  Future<void> saveVideoPath(String path) => _storage.write(key: SplashVideoStorageKeys.videoPath, value: path);
}
