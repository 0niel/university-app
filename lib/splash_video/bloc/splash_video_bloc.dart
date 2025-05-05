import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:splash_video_repository/splash_video_repository.dart';

part 'splash_video_event.dart';
part 'splash_video_state.dart';

class SplashVideoBloc extends Bloc<SplashVideoEvent, SplashVideoState> {
  SplashVideoBloc({required SplashVideoRepository splashVideoRepository})
    : _splashVideoRepository = splashVideoRepository,
      super(const SplashVideoInitial()) {
    on<CheckSplashVideoStatus>(_onCheckSplashVideoStatus);
    on<MarkSplashVideoShown>(_onMarkSplashVideoShown);
  }

  final SplashVideoRepository _splashVideoRepository;

  Future<void> _onCheckSplashVideoStatus(CheckSplashVideoStatus event, Emitter<SplashVideoState> emit) async {
    try {
      emit(const SplashVideoLoading());

      final splashVideo = await _splashVideoRepository.getSplashVideo();

      if (splashVideo != null) {
        emit(SplashVideoReady(videoPath: splashVideo.videoUrl));
      } else {
        emit(const SplashVideoSkipped());
      }
    } catch (e) {
      emit(SplashVideoError(error: e.toString()));
      emit(const SplashVideoSkipped());
    }
  }

  Future<void> _onMarkSplashVideoShown(MarkSplashVideoShown event, Emitter<SplashVideoState> emit) async {
    // This is a no-op now as we moved to a different mechanism
    emit(const SplashVideoComplete());
  }
}
