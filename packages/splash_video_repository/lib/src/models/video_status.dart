import 'package:equatable/equatable.dart';

/// {@template video_status}
/// Status of the splash video
/// {@endtemplate}
abstract class VideoStatus extends Equatable {
  /// {@macro video_status}
  const VideoStatus();

  /// Ready to show video
  const factory VideoStatus.ready({required String videoPath}) = VideoStatusReady;

  /// Skip showing the video
  const factory VideoStatus.skipped() = VideoStatusSkipped;

  @override
  List<Object?> get props => [];
}

/// Status when video is ready to be shown
class VideoStatusReady extends VideoStatus {
  /// {@macro video_status}
  const VideoStatusReady({required this.videoPath});

  /// Path to the video file
  final String videoPath;

  @override
  List<Object?> get props => [videoPath];
}

/// Status when video should be skipped
class VideoStatusSkipped extends VideoStatus {
  /// {@macro video_status}
  const VideoStatusSkipped();
}
