import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:community_repository/community_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_overview_event.dart';
part 'post_overview_bloc.freezed.dart';
part 'post_overview_state.dart';
part 'post_overview_status.dart';

class PostOverviewBloc extends Bloc<PostOverviewEvent, PostOverviewState> {
  PostOverviewBloc({required this._communityRepository})
    : super(const PostOverviewState()) {
    on<PostRequested>(_onPostRequested, transformer: droppable());
  }

  final CommunityRepository _communityRepository;

  FutureOr<void> _onPostRequested(
    PostRequested event,
    Emitter<PostOverviewState> emit,
  ) async {
    emit(state.copyWith(status: .loading));
    try {
      final post = await _communityRepository.getPost(event.postId);
      if (emit.isDone) return;

      final comments = await _loadComments(post.topicId);
      if (emit.isDone) return;

      emit(
        state.copyWith(
          post: post,
          comments:
              comments ??
              (state.post?.topicId == post.topicId
                  ? state.comments
                  : const <DiscoursePostComment>[]),
          status: comments == null ? .commentsFailure : .loaded,
        ),
      );
    } on Exception catch (error, stackTrace) {
      if (emit.isDone) return;
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  Future<List<DiscoursePostComment>?> _loadComments(int topicId) async {
    try {
      return await _communityRepository.getPostComments(topicId: topicId);
    } on Exception catch (error, stackTrace) {
      if (!isClosed) addError(error, stackTrace);
      return null;
    }
  }
}
