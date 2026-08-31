part of 'post_overview_bloc.dart';

@freezed
abstract class PostOverviewState with _$PostOverviewState {
  const factory PostOverviewState({
    DiscoursePost? post,
    @Default(<DiscoursePostComment>[]) List<DiscoursePostComment> comments,
    @Default(PostOverviewStatus.initial) PostOverviewStatus status,
  }) = _PostOverviewState;

  const PostOverviewState._();
}
