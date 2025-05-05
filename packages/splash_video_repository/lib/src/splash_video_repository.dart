import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:storage/storage.dart';
import 'models/models.dart';

part 'splash_video_storage.dart';

/// {@template splash_video_failure}
/// Base failure class for the splash video repository failures.
/// {@endtemplate}
abstract class SplashVideoFailure with EquatableMixin implements Exception {
  /// {@macro splash_video_failure}
  const SplashVideoFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object?> get props => [error];
}

/// Failure when downloading video
class DownloadVideoFailure extends SplashVideoFailure {
  const DownloadVideoFailure(super.error);
}

/// Failure when checking video status
class CheckVideoStatusFailure extends SplashVideoFailure {
  const CheckVideoStatusFailure(super.error);
}

/// {@template splash_video_repository}
/// Repository for managing splash videos
/// {@endtemplate}
abstract class SplashVideoRepository {
  /// {@macro splash_video_repository}
  const SplashVideoRepository();

  /// Gets the splash video data if available
  Future<SplashVideo?> getSplashVideo();
}

/// {@template splash_video_repository}
/// A repository that manages video splash screen data.
/// {@endtemplate}
class SplashVideoRepositoryImpl implements SplashVideoRepository {
  /// {@macro splash_video_repository}
  SplashVideoRepositoryImpl({required SplashVideoStorage storage, http.Client? httpClient})
      : splashVideoStorage = storage,
        _httpClient = httpClient ?? http.Client();

  /// The storage for splash video data
  final SplashVideoStorage splashVideoStorage;
  final http.Client _httpClient;

  /// Check if the splash video should be shown
  ///
  /// Returns [VideoStatus] indicating whether the video should be shown
  Future<VideoStatus> checkVideoStatus({required String videoUrl, required String endDate}) async {
    try {
      final endDateTime = DateTime.parse(endDate);
      final now = DateTime.now();

      // Check if current date is after end date
      if (now.isAfter(endDateTime)) {
        return const VideoStatusSkipped();
      }

      final lastShownString = await splashVideoStorage.getLastShownDate();
      final videoPath = await splashVideoStorage.getVideoPath();

      // If video path exists, check if we should show it
      if (videoPath != null && await File(videoPath).exists()) {
        // If never shown before, show it
        if (lastShownString == null) {
          return VideoStatusReady(videoPath: videoPath);
        }

        final lastShown = DateTime.parse(lastShownString);
        final difference = now.difference(lastShown);

        // Show if last shown more than 24 hours ago
        if (difference.inHours >= 24) {
          return VideoStatusReady(videoPath: videoPath);
        } else {
          return const VideoStatusSkipped();
        }
      } else {
        // No video or file doesn't exist, download it
        return await _downloadVideo(videoUrl);
      }
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(CheckVideoStatusFailure(error), stackTrace);
    }
  }

  /// Download video from the provided url
  ///
  /// Returns [VideoStatus] with the video path if download is successful
  Future<VideoStatus> _downloadVideo(String videoUrl) async {
    try {
      final response = await _httpClient.get(Uri.parse(videoUrl));

      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/splash_video.mp4';
        await File(filePath).writeAsBytes(response.bodyBytes);

        await splashVideoStorage.saveVideoPath(filePath);
        return VideoStatusReady(videoPath: filePath);
      } else {
        throw Exception('Failed to download: ${response.statusCode}');
      }
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(DownloadVideoFailure(error), stackTrace);
    }
  }

  /// Mark the video as shown at the current date and time
  Future<void> markVideoShown() async {
    final now = DateTime.now();
    await splashVideoStorage.saveLastShownDate(now.toIso8601String());
  }

  @override
  Future<SplashVideo?> getSplashVideo() async {
    try {
      final lastShownString = await splashVideoStorage.getLastShownDate();
      final videoPath = await splashVideoStorage.getVideoPath();

      if (videoPath != null && lastShownString != null && await File(videoPath).exists()) {
        // When loading from local storage without API, we use default values
        // that will show the video until a day after the last shown date
        final lastShown = DateTime.parse(lastShownString);
        final defaultEndDate = lastShown.add(const Duration(days: 2));

        return SplashVideo(
          videoUrl: videoPath,
          lastUpdated: lastShownString,
          endDate: defaultEndDate.toIso8601String(),
          isEnabled: true, // Default to enabled
        );
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
