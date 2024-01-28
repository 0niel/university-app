import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:university_app_server_api/api.dart';
import 'package:university_app_server_api/src/models/models.dart';

/// @Allow(GET)
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final dataSource = context.read<CommunityDataSource>();

  final response = ContributorsResponse(contributors: await dataSource.getContributors());

  return Response.json(body: response);
}
