sealed class NewsFailure implements Exception {
  const NewsFailure(this.error);

  final Object error;
}

final class GetFeedFailure extends NewsFailure {
  const GetFeedFailure(super.error);
}

final class GetCategoriesFailure extends NewsFailure {
  const GetCategoriesFailure(super.error);
}

final class PopularSearchFailure extends NewsFailure {
  const PopularSearchFailure(super.error);
}

final class RelevantSearchFailure extends NewsFailure {
  const RelevantSearchFailure(super.error);
}
