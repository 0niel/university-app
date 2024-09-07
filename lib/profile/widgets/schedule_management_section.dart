import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:rtu_mirea_app/gen/assets.gen.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/profile_button.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';

class ScheduleManagementSection extends StatelessWidget {
  final void Function(BuildContext) onFeedbackTap;

  const ScheduleManagementSection({Key? key, required this.onFeedbackTap}) : super(key: key);

  int _getTotalSavedSchedules(BuildContext context) {
    final groups = context.read<ScheduleBloc>().state.groupsSchedule;
    final teachers = context.read<ScheduleBloc>().state.teachersSchedule;
    final classrooms = context.read<ScheduleBloc>().state.classroomsSchedule;

    return groups.length + teachers.length + classrooms.length;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileButton(
              text: 'Группы',
              icon: HugeIcon(icon: HugeIcons.strokeRoundedUserGroup, color: AppTheme.colorsOf(context).active),
              onPressed: () => context.go('/schedule/management'),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  _getTotalSavedSchedules(context).toString(),
                  style: AppTextStyle.bodyL,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ProfileButton(
              text: "Компактный вид",
              icon: Assets.icons.hugeicons.listView.svg(color: AppTheme.colorsOf(context).active),
              trailing: Switch(
                value: state.isMiniature,
                onChanged: (value) {
                  context.read<ScheduleBloc>().add(ScheduleSetDisplayMode(isMiniature: value));
                },
              ),
            ),
            const SizedBox(height: 8),
            ProfileButton(
              text: "Пустые пары",
              icon: Assets.icons.hugeicons.listView.svg(color: AppTheme.colorsOf(context).active),
              trailing: Switch(
                value: state.showEmptyLessons,
                onChanged: (value) {
                  context.read<ScheduleBloc>().add(ScheduleSetEmptyLessonsDisplaying(showEmptyLessons: value));
                },
              ),
            ),
            const SizedBox(height: 8),
            ProfileButton(
              text: "Индикатор заметок",
              icon: Padding(
                padding: const EdgeInsets.only(left: 4, right: 4),
                child: Icon(
                  Icons.circle,
                  color: AppTheme.colorsOf(context).active,
                  size: 18,
                ),
              ),
              trailing: Switch(
                value: state.showCommentsIndicators,
                onChanged: (value) {
                  context.read<ScheduleBloc>().add(SetShowCommentsIndicator(showCommentsIndicators: value));
                },
              ),
            ),
            if (state.selectedSchedule != null) ...[
              const SizedBox(height: 8),
              ProfileButton(
                text: "Экспорт в календарь",
                icon: Assets.icons.hugeicons.calendarCheckOut01.svg(color: AppTheme.colorsOf(context).active),
                onPressed: () async {
                  try {
                    await context.read<ScheduleBloc>().exportScheduleToCalendar(state.selectedSchedule!);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Расписание успешно добавлено в календарь!'),
                        ),
                      );
                    });
                  } catch (e) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text((e as Exception).toString()),
                        ),
                      );
                    });
                  }
                },
              ),
            ],
            const SizedBox(height: 8),
            ProfileButton(
              text: "Проблемы с расписанием",
              icon: Assets.icons.hugeicons.share01.svg(color: AppTheme.colorsOf(context).active),
              onPressed: () => onFeedbackTap(context),
            ),
          ],
        );
      },
    );
  }
}
