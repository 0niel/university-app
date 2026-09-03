import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:community_repository/community_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'discourse_event.dart';
part 'discourse_bloc.freezed.dart';
part 'discourse_state.dart';
part 'discourse_status.dart';

class DiscourseBloc extends Bloc<DiscourseEvent, DiscourseState> {
  DiscourseBloc(this._communityRepository) : super(const DiscourseState()) {
    on<DiscourseTopTopicsRequested>(
      _onTopTopicsRequested,
      transformer: droppable(),
    );
    on<DiscourseTopTopicsNextPageRequested>(
      _onNextPageRequested,
      transformer: droppable(),
    );
  }

  final CommunityRepository _communityRepository;

  FutureOr<void> _onTopTopicsRequested(
    DiscourseTopTopicsRequested event,
    Emitter<DiscourseState> emit,
  ) async {
    if (state.isLoadingMore) return;
    emit(state.copyWith(status: .loading, loadMoreFailed: false));
    try {
      final results = await _communityRepository.getTopTopics();

      emit(state.copyWith(topTopics: results, status: .loaded, page: 0));
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onNextPageRequested(
    DiscourseTopTopicsNextPageRequested event,
    Emitter<DiscourseState> emit,
  ) async {
    final current = state.topTopics;
    if (state.status != .loaded ||
        state.isLoadingMore ||
        current == null ||
        !current.hasMore) {
      return;
    }
    emit(state.copyWith(isLoadingMore: true, loadMoreFailed: false));
    try {
      final nextPage = state.page + 1;
      final result = await _communityRepository.getTopTopics(page: nextPage);
      final topics = {for (final topic in current.topics) topic.id: topic};
      final users = {for (final user in current.users) user.id: user};
      final previousCount = topics.length;
      topics.addEntries(
        result.topics.map((topic) => MapEntry(topic.id, topic)),
      );
      users.addEntries(result.users.map((user) => MapEntry(user.id, user)));
      emit(
        state.copyWith(
          topTopics: TopTopicsResponse(
            topics: topics.values.toList(),
            users: users.values.toList(),
            hasMore: result.hasMore && topics.length > previousCount,
          ),
          page: nextPage,
          isLoadingMore: false,
        ),
      );
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(isLoadingMore: false, loadMoreFailed: true));
      addError(error, stackTrace);
    }
  }
}
