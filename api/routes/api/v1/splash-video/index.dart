import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:university_app_server_api/api.dart';

final _logger = getLogger('SplashVideoEndpoint');

Future<Response> onRequest(RequestContext context) async {
  final method = context.request.method;
  switch (method) {
    case HttpMethod.get:
      return _get(context);
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context) async {
  try {
    final dataSource = context.read<SplashVideoDataSource>();
    final splashVideo = await dataSource.getSplashVideo();
    return Response.json(body: splashVideo.toJson());
  } catch (e, stackTrace) {
    _logger.e('Failed to get splash video', error: e, stackTrace: stackTrace);
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Failed to get splash video'},
    );
  }
}
