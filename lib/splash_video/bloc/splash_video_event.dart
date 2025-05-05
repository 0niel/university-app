part of 'splash_video_bloc.dart';

abstract class SplashVideoEvent extends Equatable {
  const SplashVideoEvent();

  @override
  List<Object?> get props => [];
}

class CheckSplashVideoStatus extends SplashVideoEvent {
  const CheckSplashVideoStatus({required this.videoUrl, required this.endDate});

  final String videoUrl;
  final String endDate;

  @override
  List<Object?> get props => [videoUrl, endDate];
}

class DownloadSplashVideo extends SplashVideoEvent {
  const DownloadSplashVideo({required this.videoUrl});

  final String videoUrl;

  @override
  List<Object?> get props => [videoUrl];
}

class MarkSplashVideoShown extends SplashVideoEvent {
  const MarkSplashVideoShown();
}
