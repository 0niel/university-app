part of 'post_overview_bloc.dart';

abstract class PostOverviewEvent extends Equatable {
  const PostOverviewEvent();
}

class PostRequested extends PostOverviewEvent {
  const PostRequested({required this.postId});

  final int postId;

  @override
  List<Object?> get props => [postId];
}
