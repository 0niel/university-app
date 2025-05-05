import 'package:equatable/equatable.dart';
import 'package:university_app_server_api/client.dart';

/// {@template news_failure}
/// Base failure class for the news feature.
/// {@endtemplate}
abstract class NewsFailure with EquatableMixin implements Exception {
  /// {@macro news_failure}
  const NewsFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object?> get props => [error];
}

class GetNewsFailure extends NewsFailure {
  const GetNewsFailure(super.error);
}

class GetAdsFailure extends NewsFailure {
  const GetAdsFailure(super.error);
}

/// {@template community_repository}
/// A repository that manages news data.
/// {@endtemplate}
class NewsRepository {
  /// {@macro community_repository}
  const NewsRepository({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<NewsFeedResponse> getNews({
    int? limit,
    int? offset,
    String? category,
  }) async {
    try {
      return await _apiClient.getNews(limit: limit, offset: offset, category: category);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetNewsFailure(error), stackTrace);
    }
  }

  Future<NewsFeedResponse> getAds({int? limit, int? offset}) async {
    try {
      return await _apiClient.getAds(limit: limit, offset: offset);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetAdsFailure(error), stackTrace);
    }
  }
}
