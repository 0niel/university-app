import 'package:splash_video_repository/splash_video_repository.dart';
import 'package:storage/storage.dart';

/// {@template splash_video_storage_impl}
/// Storage implementation of [SplashVideoStorage]
/// {@endtemplate}
class StorageBasedSplashVideoStorage implements SplashVideoStorage {
  /// {@macro splash_video_storage_impl}
  const StorageBasedSplashVideoStorage({required Storage storage}) : _storage = storage;

  final Storage _storage;

  static const String _lastShownKey = 'splash_video_last_shown';
  static const String _videoPathKey = 'splash_video_local_path';

  @override
  Future<String?> getLastShownDate() async {
    return _storage.read(key: _lastShownKey);
  }

  @override
  Future<String?> getVideoPath() async {
    return _storage.read(key: _videoPathKey);
  }

  @override
  Future<void> saveLastShownDate(String date) async {
    await _storage.write(key: _lastShownKey, value: date);
  }

  @override
  Future<void> saveVideoPath(String path) async {
    await _storage.write(key: _videoPathKey, value: path);
  }
}
