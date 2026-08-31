part of 'feed_bloc.dart';

typedef Feed = Map<String, List<NewsBlock>>;

typedef HasMoreNews = Map<String, bool>;

@freezed
abstract class FeedState with _$FeedState {
  const factory FeedState({
    @Default(FeedStatus.initial) FeedStatus status,
    @NewsBlockMapConverter() @Default(<String, List<NewsBlock>>{}) Feed feed,
    @Default(<String, bool>{}) HasMoreNews hasMoreNews,
  }) = _FeedState;

  factory FeedState.fromJson(Map<String, dynamic> json) =>
      _$FeedStateFromJson(json);
}

enum FeedStatus { initial, loading, populated, failure }
