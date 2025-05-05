import 'dart:async';

import 'package:discourse_repository/discourse_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'post_overview_state.dart';
part 'post_overview_event.dart';

class PostOverviewBloc extends Bloc<PostOverviewEvent, PostOverviewState> {
  PostOverviewBloc({required DiscourseRepository discourseRepository})
    : _discourseRepository = discourseRepository,
      super(const PostOverviewState.initial()) {
    on<PostRequested>(_onPostRequested);
  }

  final DiscourseRepository _discourseRepository;

  FutureOr<void> _onPostRequested(PostRequested event, Emitter<PostOverviewState> emit) async {
    emit(state.copyWith(status: PostOverviewStatus.loading));
    try {
      final results = await _discourseRepository.getPost(event.postId);

      emit(state.copyWith(post: results, status: PostOverviewStatus.loaded));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: PostOverviewStatus.failure));
      addError(error, stackTrace);
    }
  }
}
