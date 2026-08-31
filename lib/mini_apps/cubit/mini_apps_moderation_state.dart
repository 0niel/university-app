part of 'mini_apps_moderation_cubit.dart';

@freezed
abstract class MiniAppsModerationState with _$MiniAppsModerationState {
  const factory MiniAppsModerationState({
    @Default(MiniAppsModerationStatus.initial) MiniAppsModerationStatus status,
    @Default(MiniAppsModerationQueue()) MiniAppsModerationQueue queue,
    String? processingAppId,
  }) = _MiniAppsModerationState;
}
