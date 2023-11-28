import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:university_app_server_api/api.dart';
import 'package:university_app_server_api/src/models/news_feed_response/news_feed_response.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final queryParams = context.request.url.queryParameters;
  final limit = int.tryParse(queryParams['limit'] ?? '') ?? 20;
  final offset = int.tryParse(queryParams['offset'] ?? '') ?? 0;
  final newsDataSource = context.read<NewsDataSource>();

  final news = await newsDataSource.getAds(
    limit: limit,
    offset: offset,
  );

  final response =
      NewsFeedResponse(news: news.map(NewsItemResponse.fromNewsItem).toList());

  return Response.json(body: response);
}
