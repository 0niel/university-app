import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:university_app_server_api/client.dart';

class SchedulesList extends StatelessWidget {
  const SchedulesList({super.key});

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

  void _showSnackbar(BuildContext context, String message, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
      ),
    );
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
                style: AppTextStyle.chip.copyWith(color: AppColors.dark.deactive),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              if (state.selectedSchedule != null)
                SelectedScheduleItemButton(
                  text: _getNameBySelectedSchedule(state.selectedSchedule!),
                  isSelected: true,
                  onRefreshPressed: () => context.read<ScheduleBloc>().add(
                        const RefreshSelectedScheduleData(),
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
                        _showSnackbar(context, "Удалено расписание группы ${el.$2.name}", Icons.delete);
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
                        _showSnackbar(context, "Выбрано расписание группы ${el.$2.name}", Icons.check);
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
                          _showSnackbar(context, "Удалено расписание преподавателя ${el.$2.name}", Icons.delete);
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
                          _showSnackbar(context, "Выбрано расписание преподавателя ${el.$2.name}", Icons.check);
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
                        _showSnackbar(context, "Выбрано расписание аудитории ${el.$2.name}", Icons.check);
                      },
                      onDeletePressed: () {
                        context.read<ScheduleBloc>().add(
                              DeleteSchedule(
                                identifier: el.$1,
                                target: ScheduleTarget.classroom,
                              ),
                            );
                        _showSnackbar(context, "Удалено расписание аудитории ${el.$2.name}", Icons.delete);
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
