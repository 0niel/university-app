import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:university_app_server_api/api.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final newsDataSource = context.read<NewsDataSource>();

  final article = await newsDataSource.getArticle(id: id);

  if (article == null) return Response(statusCode: HttpStatus.notFound);

  final response = ArticleResponse(
    title: article.title,
    content: article.blocks,
    url: article.url,
  );

  return Response.json(body: response);
}
