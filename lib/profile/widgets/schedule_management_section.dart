import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/profile/widgets/widgets.dart';
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
          return Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
            color: Theme.of(context).extension<AppColors>()!.background02,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileButton(
                    text: 'Группы',
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedUserGroup,
                      size: 26,
                      color: Theme.of(context).extension<AppColors>()!.primary,
                    ),
                    onPressed: () => context.go('/profile/schedule-management'),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).extension<AppColors>()!.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getTotalSavedSchedules(context).toString(),
                        style: AppTextStyle.bodyL.copyWith(
                          color: Theme.of(context).extension<AppColors>()!.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 24, thickness: 0.5),
                  _SettingToggleRow(
                    title: "Компактный вид",
                    icon: Assets.icons.hugeicons.listView.svg(
                      color: Theme.of(context).extension<AppColors>()!.primary,
                      height: 24,
                    ),
                    value: state.isMiniature,
                    onChanged: (value) {
                      context.read<ScheduleBloc>().add(ScheduleSetDisplayMode(isMiniature: value));
                    },
                  ),
                  const SizedBox(height: 16),
                  _SettingToggleRow(
                    title: "Пустые пары",
                    icon: Icon(
                      Icons.event_busy_outlined,
                      color: Theme.of(context).extension<AppColors>()!.primary,
                      size: 24,
                    ),
                    value: state.showEmptyLessons,
                    onChanged: (value) {
                      context.read<ScheduleBloc>().add(ScheduleSetEmptyLessonsDisplaying(showEmptyLessons: value));
                    },
                  ),
                  const SizedBox(height: 16),
                  _SettingToggleRow(
                    title: "Индикатор заметок",
                    icon: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).extension<AppColors>()!.primary, width: 2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.circle, color: Theme.of(context).extension<AppColors>()!.primary, size: 14),
                    ),
                    value: state.showCommentsIndicators,
                    onChanged: (value) {
                      context.read<ScheduleBloc>().add(SetShowCommentsIndicator(showCommentsIndicators: value));
                    },
                  ),
                  if (state.selectedSchedule != null) ...[
                    const Divider(height: 32, thickness: 0.5),
                    ProfileButton(
                      text: "Экспорт в календарь",
                      icon: Assets.icons.hugeicons.calendarCheckOut01.svg(
                        color: Theme.of(context).extension<AppColors>()!.primary,
                        height: 24,
                      ),
                      onPressed: () async {
                        final calendarName = _getCalendarName(state.selectedSchedule!);
                        final lessons = state.selectedSchedule!.schedule.whereType<LessonSchedulePart>().toList();

                        BottomModalSheet.show(
                          context,
                          title: 'Экспорт в календарь',
                          isExpandable: true,
                          isDismissible: true,
                          showFullScreen: true,
                          minFraction: 0.33,
                          child: ExportScheduleModalContent(calendarName: calendarName, lessons: lessons),
                        );
                      },
                    ),
                  ],
                  const Divider(height: 32, thickness: 0.5),
                  ProfileButton(
                    text: "Проблемы с расписанием",
                    icon: Assets.icons.hugeicons.share01.svg(
                      color: Theme.of(context).extension<AppColors>()!.colorful07,
                      height: 24,
                    ),
                    onPressed: () => onFeedbackTap(context),
                  ),
                ],
              ),
            ),
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

class _SettingToggleRow extends StatelessWidget {
  final String title;
  final Widget icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingToggleRow({required this.title, required this.icon, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).extension<AppColors>()!.background03,
                borderRadius: BorderRadius.circular(12),
              ),
              child: icon,
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: AppTextStyle.bodyL.copyWith(fontWeight: FontWeight.w500))),
            PlatformSwitch(
              value: value,
              onChanged: onChanged,
              activeColor: Theme.of(context).extension<AppColors>()!.primary,
            ),
          ],
        ),
      ),
    );
  }
}
