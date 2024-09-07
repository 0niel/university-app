import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/primary_button.dart';
import 'package:rtu_mirea_app/schedule/models/selected_schedule.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/schedule_management/widgets/widgets.dart';
import 'package:university_app_server_api/client.dart';

class ScheduleBody extends StatelessWidget {
  final ScheduleState state;

  const ScheduleBody({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryButton(text: 'Добавить расписание', onClick: () => context.go('/schedule/search')),
        const SizedBox(height: 16),
        if (state.groupsSchedule.isNotEmpty)
          ScheduleSection<Group>(
            title: "Группы",
            schedules: _getUniqueSchedules<Group>(state.groupsSchedule),
            state: state,
            scheduleType: 'group',
          ),
        if (state.teachersSchedule.isNotEmpty)
          ScheduleSection<Teacher>(
            title: "Преподаватели",
            schedules: _getUniqueSchedules<Teacher>(state.teachersSchedule),
            state: state,
            scheduleType: 'teacher',
          ),
        if (state.classroomsSchedule.isNotEmpty)
          ScheduleSection<Classroom>(
            title: "Аудитории",
            schedules: _getUniqueSchedules<Classroom>(state.classroomsSchedule),
            state: state,
            scheduleType: 'classroom',
          ),
      ],
    );
  }

  List<(UID, T, List<SchedulePart>)> _getUniqueSchedules<T>(List<(UID, T, List<SchedulePart>)> schedules) {
    final uniqueSchedules = <String, (UID, T, List<SchedulePart>)>{};

    for (var schedule in schedules) {
      final scheduleName = SelectedSchedule.getScheduleName<T>(schedule.$2);
      if (!uniqueSchedules.containsKey(scheduleName)) {
        uniqueSchedules[scheduleName] = schedule;
      }
    }

    return uniqueSchedules.values.toList();
  }
}
