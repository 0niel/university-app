import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';

import '../bloc/schedule_bloc.dart';
import 'widgets.dart';

class SchedulesList extends StatelessWidget {
  const SchedulesList({Key? key}) : super(key: key);

  String _getNameBySelectedSchedule(SelectedSchedule schedule) {
    if (schedule is SelectedGroupSchedule) {
      return schedule.group.name;
    } else if (schedule is SelectedTeacherSchedule) {
      return schedule.teacher.name;
    } else if (schedule is SelectedClassroomSchedule) {
      return schedule.classroom.name;
    } else {
      return "неизвестно";
    }
  }

  String _getIdentifierBySelectedSchedule(SelectedSchedule schedule) {
    if (schedule is SelectedGroupSchedule) {
      return schedule.group.uid ?? schedule.group.name;
    } else if (schedule is SelectedTeacherSchedule) {
      return schedule.teacher.uid ?? schedule.teacher.name;
    } else if (schedule is SelectedClassroomSchedule) {
      return schedule.classroom.uid ?? schedule.classroom.name;
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<ScheduleBloc>().state;

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            "Сохранено".toUpperCase(),
            style: AppTextStyle.chip
                .copyWith(color: AppTheme.colors.deactiveDarker),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 10),
          if (state.selectedSchedule != null)
            SelectedScheduleItemButton(
              text: _getNameBySelectedSchedule(state.selectedSchedule!),
              isSelected: true,
              onRefreshPressed: () => context.read<ScheduleBloc>().add(
                    ScheduleRefreshRequested(
                      identifier: _getIdentifierBySelectedSchedule(
                        state.selectedSchedule!,
                      ),
                      target: SelectedSchedule.toScheduleTarget(
                        state.selectedSchedule!.type,
                      ),
                    ),
                  ),
            ),
          ...state.groupsSchedule.map(
            (group) => SelectedScheduleItemButton(
              text: group.$2.name,
              isSelected: false,
              onRefreshPressed: () => {},
            ),
          ),
          ...state.teachersSchedule.map(
            (teacher) => SelectedScheduleItemButton(
              text: teacher.$2.name,
              isSelected: false,
              onRefreshPressed: () => {},
            ),
          ),
          ...state.classroomsSchedule.map(
            (classroom) => SelectedScheduleItemButton(
              text: classroom.$2.name,
              isSelected: false,
              onRefreshPressed: () => {},
            ),
          )
        ],
      ),
    );
  }
}
