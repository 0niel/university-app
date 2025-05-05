part of 'splash_video_bloc.dart';

abstract class SplashVideoState extends Equatable {
  const SplashVideoState();

  @override
  List<Object?> get props => [];
}

class SplashVideoInitial extends SplashVideoState {
  const SplashVideoInitial();
}

class SplashVideoLoading extends SplashVideoState {
  const SplashVideoLoading();
}

class SplashVideoDownloading extends SplashVideoState {
  const SplashVideoDownloading();
}

class SplashVideoReady extends SplashVideoState {
  const SplashVideoReady({required this.videoPath});

  final String videoPath;

  @override
  List<Object?> get props => [videoPath];
}

class SplashVideoError extends SplashVideoState {
  const SplashVideoError({required this.error});

  final String error;

  @override
  List<Object?> get props => [error];
}

class SplashVideoSkipped extends SplashVideoState {
  const SplashVideoSkipped();
}

class SplashVideoComplete extends SplashVideoState {
  const SplashVideoComplete();
}
