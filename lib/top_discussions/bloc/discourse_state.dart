part of 'discourse_bloc.dart';

@freezed
abstract class DiscourseState with _$DiscourseState {
  const factory DiscourseState({
    TopTopicsResponse? topTopics,
    @Default(DiscourseStatus.initial) DiscourseStatus status,
    @Default(false) bool isLoadingMore,
    @Default(false) bool loadMoreFailed,
    @Default(0) int page,
  }) = _DiscourseState;

  const DiscourseState._();

  bool get hasTrendingContent =>
      status == DiscourseStatus.loading ||
      (status == DiscourseStatus.loaded &&
          (topTopics?.topics.isNotEmpty ?? false));

  bool get showTrendingSection =>
      hasTrendingContent || status == DiscourseStatus.failure;
}
