import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/profile/widgets/widgets.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/schedule_management/bloc/schedule_exporter_cubit.dart';
import 'package:university_app_server_api/client.dart';

class ScheduleManagementSection extends StatelessWidget {
  final void Function(BuildContext) onFeedbackTap;

  const ScheduleManagementSection({super.key, required this.onFeedbackTap});

  int _getTotalSavedSchedules(BuildContext context) {
    final groups = context.read<ScheduleBloc>().state.groupsSchedule;
    final teachers = context.read<ScheduleBloc>().state.teachersSchedule;
    final classrooms = context.read<ScheduleBloc>().state.classroomsSchedule;

    return groups.length + teachers.length + classrooms.length;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScheduleExporterCubit, ScheduleExporterState>(
      listener: (context, state) {
        if (state.isSuccess) {
          ScaffoldMessengerHelper.showMessage(context: context, title: 'Расписание экспортировано');
        } else if (state.errorMessage.isNotEmpty) {
          ScaffoldMessengerHelper.showMessage(
            context: context,
            title: 'Ошибка',
            subtitle: 'Не удалось экспортировать расписание',
            isSuccess: false,
          );
        }
      },
      child: BlocBuilder<ScheduleBloc, ScheduleState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileButton(
                text: 'Группы',
                icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedUserGroup, color: Theme.of(context).extension<AppColors>()!.active),
                onPressed: () => context.go('/profile/schedule-management'),
                trailing: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    _getTotalSavedSchedules(context).toString(),
                    style: AppTextStyle.bodyL.copyWith(color: Theme.of(context).extension<AppColors>()!.active),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ProfileButton(
                text: "Компактный вид",
                icon: Assets.icons.hugeicons.listView.svg(color: Theme.of(context).extension<AppColors>()!.active),
                trailing: PlatformSwitch(
                  value: state.isMiniature,
                  onChanged: (value) {
                    context.read<ScheduleBloc>().add(ScheduleSetDisplayMode(isMiniature: value));
                  },
                ),
                onPressed: () {
                  final newValue = !state.isMiniature;
                  context.read<ScheduleBloc>().add(ScheduleSetDisplayMode(isMiniature: newValue));
                },
              ),
              const SizedBox(height: 8),
              ProfileButton(
                text: "Пустые пары",
                icon: Assets.icons.hugeicons.listView.svg(color: Theme.of(context).extension<AppColors>()!.active),
                trailing: PlatformSwitch(
                  value: state.showEmptyLessons,
                  onChanged: (value) {
                    context.read<ScheduleBloc>().add(ScheduleSetEmptyLessonsDisplaying(showEmptyLessons: value));
                  },
                ),
                onPressed: () {
                  final newValue = !state.showEmptyLessons;
                  context.read<ScheduleBloc>().add(ScheduleSetEmptyLessonsDisplaying(showEmptyLessons: newValue));
                },
              ),
              const SizedBox(height: 8),
              ProfileButton(
                text: "Индикатор заметок",
                icon: Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: Icon(
                    Icons.circle,
                    color: Theme.of(context).extension<AppColors>()!.active,
                    size: 18,
                  ),
                ),
                trailing: PlatformSwitch(
                  value: state.showCommentsIndicators,
                  onChanged: (value) {
                    context.read<ScheduleBloc>().add(SetShowCommentsIndicator(showCommentsIndicators: value));
                  },
                ),
                onPressed: () {
                  final newValue = !state.showCommentsIndicators;
                  context.read<ScheduleBloc>().add(SetShowCommentsIndicator(showCommentsIndicators: newValue));
                },
              ),
              if (state.selectedSchedule != null) ...[
                const SizedBox(height: 8),
                ProfileButton(
                  text: "Экспорт в календарь",
                  icon: Assets.icons.hugeicons.calendarCheckOut01
                      .svg(color: Theme.of(context).extension<AppColors>()!.active),
                  onPressed: () async {
                    final calendarName = _getCalendarName(state.selectedSchedule!);
                    final lessons = state.selectedSchedule!.schedule.whereType<LessonSchedulePart>().toList();

                    BottomModalSheet.show(
                      context,
                      title: 'Экспорт в календарь',
                      description: 'Выберите настройки для экспорта расписания в календарь вашего устройства.',
                      child: ExportScheduleModalContent(
                        calendarName: calendarName,
                        lessons: lessons,
                      ),
                    );
                  },
                ),
              ],
              const SizedBox(height: 8),
              ProfileButton(
                text: "Проблемы с расписанием",
                icon: Assets.icons.hugeicons.share01.svg(color: Theme.of(context).extension<AppColors>()!.active),
                onPressed: () => onFeedbackTap(context),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Determines the calendar name based on the selected schedule type.
  String _getCalendarName(SelectedSchedule selectedSchedule) {
    switch (selectedSchedule.runtimeType) {
      case SelectedGroupSchedule:
        return (selectedSchedule as SelectedGroupSchedule).group.name;
      case SelectedTeacherSchedule:
        return _formatTeacherName((selectedSchedule as SelectedTeacherSchedule).teacher.name);
      case SelectedClassroomSchedule:
        return (selectedSchedule as SelectedClassroomSchedule).classroom.name;
      default:
        return 'Mirea Ninja Schedule';
    }
  }

  /// Formats the teacher's name for the calendar.
  String _formatTeacherName(String teacherName) {
    final nameParts = teacherName.split(' ');
    if (nameParts.length < 2) return teacherName;
    return '${nameParts[0]} ${nameParts[1][0]}.';
  }
}
