import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_request_logger/dart_frog_request_logger.dart';
import 'package:university_app_server_api/src/data/schedule/schedule_data_source.dart';
import 'package:university_app_server_api/src/models/models.dart';
import 'package:university_app_server_api/src/redis.dart';

/// @Allow(GET)
Future<Response> onRequest(RequestContext context, String group) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final scheduleDataSource = context.read<ScheduleDataSource>();
  final redisClient = context.read<RedisClient>();
  final logger = context.read<RequestLogger>();

  try {
    final schedule = await scheduleDataSource.getSchedule(group: group);
    logger.debug('Fetched schedule for group $group');

    final scheduleData = ScheduleResponse(data: schedule).toJson();
    final scheduleDataString = json.encode(scheduleData);
    // Cache the schedule for 30 minutes.
    await redisClient.command.send_object(['SET', 'schedule:$group', scheduleDataString, 'EX', 1800]);
    logger.debug('Cached schedule for group $group');

    return Response.json(body: ScheduleResponse(data: schedule));
  } catch (e) {
    final lastKnownSchedule = await redisClient.command.get('schedule:$group');
    if (lastKnownSchedule != null) {
      logger.debug('Failed to fetch schedule for group $group. Returning last known schedule.');
      return Response.json(
        body: ScheduleResponse.fromJson(json.decode(lastKnownSchedule as String) as Map<String, dynamic>),
      );
    } else {
      logger.error('Failed to fetch schedule for group $group: $e');
      return Response(statusCode: HttpStatus.internalServerError);
    }
  }
}
