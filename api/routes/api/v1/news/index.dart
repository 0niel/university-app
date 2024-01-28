import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:university_app_server_api/api.dart';
import 'package:university_app_server_api/src/models/models.dart';

/// @Allow(GET)
/// @Query(limit)
/// @Query(offset)
/// @Query(category)
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final queryParams = context.request.url.queryParameters;
  final limit = int.tryParse(queryParams['limit'] ?? '') ?? 20;
  final offset = int.tryParse(queryParams['offset'] ?? '') ?? 0;
  final category = queryParams['category'];
  final newsDataSource = context.read<NewsDataSource>();

  final news = await newsDataSource.getNews(
    limit: limit,
    offset: offset,
    category: category,
  );

  final response = NewsFeedResponse(
    news: news
        .map(
          (article) => NewsItemResponse(
            title: article.title,
            htmlContent: article.htmlContent,
            publishedAt: article.publishedAt,
            imageUrls: article.imageUrls,
            categories: article.categories,
            url: article.url,
          ),
        )
        .toList(),
  );

  return Response.json(body: response);
}
