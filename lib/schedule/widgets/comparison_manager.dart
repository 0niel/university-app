import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:app_ui/app_ui.dart';

class ComparisonManager extends StatelessWidget {
  const ComparisonManager({super.key});

  String _getScheduleTitle(SelectedSchedule schedule) {
    if (schedule is SelectedGroupSchedule) {
      return schedule.group.name;
    } else if (schedule is SelectedTeacherSchedule) {
      return schedule.teacher.name;
    } else if (schedule is SelectedClassroomSchedule) {
      return schedule.classroom.name;
    } else {
      return 'Неизвестно';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        final savedSchedules = [
          ...state.groupsSchedule.map(
            (e) => SelectedGroupSchedule(group: e.$2, schedule: e.$3),
          ),
          ...state.teachersSchedule.map(
            (e) => SelectedTeacherSchedule(teacher: e.$2, schedule: e.$3),
          ),
          ...state.classroomsSchedule.map(
            (e) => SelectedClassroomSchedule(classroom: e.$2, schedule: e.$3),
          ),
        ];

        return SizedBox(
          height: min(420, MediaQuery.of(context).size.height * 0.3),
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                  itemCount: savedSchedules.length,
                  itemBuilder: (context, index) {
                    final schedule = savedSchedules[index];
                    final isInComparison = state.comparisonSchedules.contains(schedule);

                    return ListTile(
                      visualDensity: VisualDensity.compact,
                      title: Text(
                        _getScheduleTitle(schedule),
                        style: AppTextStyle.titleS.copyWith(
                          color: AppColors.dark.active,
                        ),
                      ),
                      trailing: Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          value: isInComparison,
                          onChanged: (value) {
                            if (isInComparison) {
                              context.read<ScheduleBloc>().add(RemoveScheduleFromComparison(schedule));
                            } else {
                              if (state.comparisonSchedules.length < 3) {
                                context.read<ScheduleBloc>().add(AddScheduleToComparison(schedule));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Максимум 3 расписаний для сравнения'),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              PrimaryButton(
                text: 'Закрыть',
                onClick: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
