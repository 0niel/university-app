import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_repository/news_repository.dart';

part 'feed_bloc.freezed.dart';
part 'feed_bloc.g.dart';
part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends HydratedBloc<FeedEvent, FeedState> {
  FeedBloc({required this.newsRepository}) : super(const FeedState()) {
    on<FeedRequested>(_onFeedRequested, transformer: sequential());
    on<FeedRefreshRequested>(_onFeedRefreshRequested, transformer: droppable());
    on<FeedResumed>(_onFeedResumed, transformer: droppable());
  }

  final NewsRepository newsRepository;

  Future<void> _onFeedRequested(
    FeedRequested event,
    Emitter<FeedState> emit,
  ) {
    emit(state.copyWith(status: .loading));
    return _updateFeed(categoryId: event.category.id, emit: emit);
  }

  FutureOr<void> _onFeedResumed(
    FeedResumed event,
    Emitter<FeedState> emit,
  ) async {
    await Future.wait<void>(
      state.feed.keys.map(
        (category) => _updateFeed(categoryId: category, emit: emit),
      ),
    );
  }

  Future<void> _updateFeed({
    required String categoryId,
    required Emitter<FeedState> emit,
  }) async {
    try {
      final categoryFeed = state.feed[categoryId] ?? [];
      final response = await newsRepository.getFeed(
        categoryId: categoryId,
        offset: categoryFeed.length,
      );

      final updatedCategoryFeed = [...categoryFeed, ...response.feed];
      final hasMoreNewsForCategory =
          response.totalCount > updatedCategoryFeed.length;

      emit(
        state.copyWith(
          status: .populated,
          feed: Map.of(state.feed)..addAll({categoryId: updatedCategoryFeed}),
          hasMoreNews: Map.of(state.hasMoreNews)
            ..addAll({categoryId: hasMoreNewsForCategory}),
        ),
      );
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  @override
  FeedState fromJson(Map<String, dynamic> json) => .fromJson(json);

  @override
  Map<String, dynamic> toJson(FeedState state) => state.toJson();

  FutureOr<void> _onFeedRefreshRequested(
    FeedRefreshRequested event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(status: .loading));

    try {
      final category = event.category;

      final response = await newsRepository.getFeed(
        categoryId: category.id,
      );

      final refreshedCategoryFeed = response.feed;
      final hasMoreNewsForCategory =
          response.totalCount > refreshedCategoryFeed.length;

      emit(
        state.copyWith(
          status: .populated,
          feed: Map.of(state.feed)
            ..addAll({category.id: refreshedCategoryFeed}),
          hasMoreNews: Map.of(state.hasMoreNews)
            ..addAll({category.id: hasMoreNewsForCategory}),
        ),
      );
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }
}
