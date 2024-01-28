import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:university_app_server_api/src/data/schedule/schedule_data_source.dart';
import 'package:university_app_server_api/src/models/schedule/search_groups_response.dart';

/// @Allow(GET)
/// @Query(query)
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final queryParams = context.request.url.queryParameters;
  final query = queryParams['query'];

  if (query == null) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  final scheduleDataSource = context.read<ScheduleDataSource>();

  final groups = await scheduleDataSource.searchGroups(query: query);

  final response = SearchGroupsResponse(
    results: groups,
  );

  return Response.json(body: response);
}
