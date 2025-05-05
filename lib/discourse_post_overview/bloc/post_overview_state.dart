part of 'post_overview_bloc.dart';

enum PostOverviewStatus { initial, loading, loaded, failure }

class PostOverviewState extends Equatable {
  const PostOverviewState({required this.post, required this.status});

  const PostOverviewState.initial() : this(post: null, status: PostOverviewStatus.initial);

  final Post? post;
  final PostOverviewStatus status;

  @override
  List<Object?> get props => [post, status];

  PostOverviewState copyWith({Post? post, PostOverviewStatus? status}) {
    return PostOverviewState(post: post ?? this.post, status: status ?? this.status);
  }
}
