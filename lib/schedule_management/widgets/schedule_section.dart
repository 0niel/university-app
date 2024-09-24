import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/schedule_management/widgets/widgets.dart';
import 'package:rtu_mirea_app/search/search.dart';
import 'package:university_app_server_api/client.dart';

class ScheduleSection<T> extends StatelessWidget {
  final String title;
  final List<(UID, T, List<SchedulePart>)> schedules;
  final ScheduleState state;
  final String scheduleType;

  const ScheduleSection({
    super.key,
    required this.title,
    required this.schedules,
    required this.state,
    required this.scheduleType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchHeadlineText(headerText: title),
        const SizedBox(height: 8),
        Column(
          children: schedules.map((schedule) {
            return ScheduleCard<T>(
              schedule: schedule,
              state: state,
              scheduleType: scheduleType,
            );
          }).toList(),
        ),
      ],
    );
  }
}
