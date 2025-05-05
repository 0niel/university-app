import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_ui/app_ui.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';

/// Desktop-optimized panel for displaying profile and schedule selection info
class DesktopAccountPanel extends StatelessWidget {
  const DesktopAccountPanel({super.key, required this.onSelectSchedule});

  final VoidCallback onSelectSchedule;

  @override
  Widget build(BuildContext context) {
    final state = context.select((ScheduleBloc bloc) => bloc.state);
    final colors = Theme.of(context).extension<AppColors>()!;

    String scheduleTitle = 'Выберите расписание';
    String scheduleSubtitle = 'Нажмите, чтобы выбрать';
    IconData iconData = HugeIcons.strokeRoundedUniversity;
    Color iconColor = colors.deactive;

    if (state.selectedSchedule != null) {
      if (state.selectedSchedule is SelectedGroupSchedule) {
        final selectedSchedule = state.selectedSchedule as SelectedGroupSchedule;
        scheduleTitle = selectedSchedule.group.name;
        scheduleSubtitle = 'Группа';
        iconData = HugeIcons.strokeRoundedUserGroup;
        iconColor = colors.colorful01;
      } else if (state.selectedSchedule is SelectedTeacherSchedule) {
        final selectedSchedule = state.selectedSchedule as SelectedTeacherSchedule;
        scheduleTitle = selectedSchedule.teacher.name;
        scheduleSubtitle = 'Преподаватель';
        iconData = HugeIcons.strokeRoundedTeacher;
        iconColor = colors.colorful02;
      } else if (state.selectedSchedule is SelectedClassroomSchedule) {
        final selectedSchedule = state.selectedSchedule as SelectedClassroomSchedule;
        final campus = selectedSchedule.classroom.campus?.shortName ?? '';
        scheduleTitle = selectedSchedule.classroom.name;
        scheduleSubtitle = campus.isNotEmpty ? 'Аудитория ($campus)' : 'Аудитория';
        iconData = HugeIcons.strokeRoundedBuilding04;
        iconColor = colors.colorful03;
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.background03.withOpacity(0.2),
        border: Border(bottom: BorderSide(color: colors.background03, width: 1)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onSelectSchedule,
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Center(child: HugeIcon(icon: iconData, size: 24, color: iconColor)),
            ),

            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scheduleTitle,
                    style: AppTextStyle.bodyL.copyWith(color: colors.active, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(scheduleSubtitle, style: AppTextStyle.captionL.copyWith(color: colors.deactive)),
                ],
              ),
            ),

            // Action button
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: colors.background03.withOpacity(0.5), shape: BoxShape.circle),
              child: Center(child: Icon(Icons.keyboard_arrow_right_rounded, color: colors.deactive, size: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
