import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:university_app_server_api/src/data/schedule/schedule_data_source.dart';
import 'package:university_app_server_api/src/models/models.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final queryParams = context.request.url.queryParameters;
  final group = queryParams['group'];

  if (group == null) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  final scheduleDataSource = context.read<ScheduleDataSource>();

  final schedule = await scheduleDataSource.getSchedule(group: group);

  final response = ScheduleResponse(
    group: group,
    scheduleParts: schedule,
  );

  return Response.json(body: response);
}
