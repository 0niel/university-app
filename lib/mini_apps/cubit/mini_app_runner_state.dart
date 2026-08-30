part of 'mini_app_runner_cubit.dart';

@freezed
abstract class MiniAppRunnerState with _$MiniAppRunnerState {
  const factory MiniAppRunnerState({
    @Default(MiniAppRunnerStatus.initial) MiniAppRunnerStatus status,
    MiniApp? app,
    Map<String, dynamic>? screen,
    @Default(false) bool fromCache,
  }) = _MiniAppRunnerState;
}
