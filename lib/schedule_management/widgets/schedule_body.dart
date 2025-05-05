import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/schedule_management/widgets/widgets.dart';
import 'package:university_app_server_api/client.dart';

class ScheduleBody extends StatelessWidget {
  final ScheduleState state;

  const ScheduleBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final hasGroups = state.groupsSchedule.isNotEmpty;
    final hasTeachers = state.teachersSchedule.isNotEmpty;
    final hasClassrooms = state.classroomsSchedule.isNotEmpty;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        if (hasGroups)
          ScheduleSection<Group>(title: 'Группы', schedules: state.groupsSchedule, state: state, scheduleType: 'group'),
        if (hasTeachers)
          ScheduleSection<Teacher>(
            title: 'Преподаватели',
            schedules: state.teachersSchedule,
            state: state,
            scheduleType: 'teacher',
          ),
        if (hasClassrooms)
          ScheduleSection<Classroom>(
            title: 'Аудитории',
            schedules: state.classroomsSchedule,
            state: state,
            scheduleType: 'classroom',
          ),
        const SizedBox(height: 80),
      ],
    ).animate().fadeIn(duration: 500.ms);
  }
}
