part of 'feed_bloc.dart';

@freezed
sealed class FeedEvent with _$FeedEvent {
  const factory FeedEvent.requested({required Category category}) =
      FeedRequested;

  const factory FeedEvent.refreshRequested({required Category category}) =
      FeedRefreshRequested;

  const factory FeedEvent.resumed() = FeedResumed;
}
