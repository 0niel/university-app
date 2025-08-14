import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:university_app_server_api/api.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final queryParams = context.request.url.queryParameters;
  final limit = int.tryParse(queryParams['limit'] ?? '') ?? 20;
  final offset = int.tryParse(queryParams['offset'] ?? '') ?? 0;
  final previewRequested = queryParams['preview'] == 'true';
  final newsDataSource = context.read<NewsDataSource>();

  final showFullArticle = !previewRequested;

  final article = await newsDataSource.getArticle(
    id: id,
    limit: limit,
    offset: offset,
    preview: !showFullArticle,
  );

  if (article == null) return Response(statusCode: HttpStatus.notFound);

  final response = ArticleResponse(
    title: article.title,
    content: article.blocks,
    totalCount: article.totalBlocks,
    url: article.url,
    isPreview: !showFullArticle,
  );

  return Response.json(body: response);
}
