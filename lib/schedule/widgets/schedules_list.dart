import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:university_app_server_api/client.dart';

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

  UID _getSelectedScheduleUid(SelectedSchedule? selectedSchedule) {
    if (selectedSchedule is SelectedGroupSchedule) {
      return selectedSchedule.group.uid ?? selectedSchedule.group.name;
    } else if (selectedSchedule is SelectedTeacherSchedule) {
      return selectedSchedule.teacher.uid ?? selectedSchedule.teacher.name;
    } else if (selectedSchedule is SelectedClassroomSchedule) {
      return selectedSchedule.classroom.uid ?? selectedSchedule.classroom.name;
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                "Сохранено".toUpperCase(),
                style: AppTextStyle.chip.copyWith(color: AppTheme.colors.deactive),
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
              ...state.groupsSchedule.where((el) => el.$1 != _getSelectedScheduleUid(state.selectedSchedule)).map(
                    (el) => SelectedScheduleItemButton(
                      text: el.$2.name,
                      isSelected: false,
                      onRefreshPressed: () => {},
                      onDeletePressed: () {
                        context.read<ScheduleBloc>().add(
                              DeleteSchedule(
                                identifier: el.$1,
                                target: ScheduleTarget.group,
                              ),
                            );
                        context.pop();
                      },
                      onSelectedPressed: () {
                        context.read<ScheduleBloc>().add(
                              SetSelectedSchedule(
                                selectedSchedule: SelectedGroupSchedule(
                                  group: el.$2,
                                  schedule: el.$3,
                                ),
                              ),
                            );
                        context.pop();
                      },
                    ),
                  ),
              ...state.teachersSchedule.where((el) => el.$1 != _getSelectedScheduleUid(state.selectedSchedule)).map(
                    (el) => SelectedScheduleItemButton(
                        text: el.$2.name,
                        isSelected: false,
                        onRefreshPressed: () => {},
                        onDeletePressed: () {
                          context.read<ScheduleBloc>().add(
                                DeleteSchedule(
                                  identifier: el.$1,
                                  target: ScheduleTarget.teacher,
                                ),
                              );
                          context.pop();
                        },
                        onSelectedPressed: () {
                          context.read<ScheduleBloc>().add(
                                SetSelectedSchedule(
                                  selectedSchedule: SelectedTeacherSchedule(
                                    teacher: el.$2,
                                    schedule: el.$3,
                                  ),
                                ),
                              );
                          context.pop();
                        }),
                  ),
              ...state.classroomsSchedule.where((el) => el.$1 != _getSelectedScheduleUid(state.selectedSchedule)).map(
                    (el) => SelectedScheduleItemButton(
                      text: el.$2.name,
                      isSelected: false,
                      onRefreshPressed: () => {},
                      onSelectedPressed: () {
                        context.read<ScheduleBloc>().add(
                              SetSelectedSchedule(
                                selectedSchedule: SelectedClassroomSchedule(
                                  classroom: el.$2,
                                  schedule: el.$3,
                                ),
                              ),
                            );
                        context.pop();
                      },
                      onDeletePressed: () {
                        context.read<ScheduleBloc>().add(
                              DeleteSchedule(
                                identifier: el.$1,
                                target: ScheduleTarget.classroom,
                              ),
                            );
                        context.pop();
                      },
                    ),
                  )
            ],
          ),
        );
      },
    );
  }
}
