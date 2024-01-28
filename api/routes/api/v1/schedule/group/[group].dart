import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:university_app_server_api/src/data/schedule/schedule_data_source.dart';
import 'package:university_app_server_api/src/models/models.dart';

/// @Allow(GET)
Future<Response> onRequest(RequestContext context, String group) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final scheduleDataSource = context.read<ScheduleDataSource>();

  final schedule = await scheduleDataSource.getSchedule(group: group);

  final response = ScheduleResponse(
    data: schedule,
  );

  return Response.json(body: response);
}
