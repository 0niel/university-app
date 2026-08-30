part of 'mini_app_submit_cubit.dart';

@freezed
abstract class MiniAppSubmitState with _$MiniAppSubmitState {
  const factory MiniAppSubmitState({
    @Default(MiniAppSubmitStatus.idle) MiniAppSubmitStatus status,
  }) = _MiniAppSubmitState;
}
