import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:university_app_server_api/client.dart';

class ComparisonLessonsTable extends StatelessWidget {
  const ComparisonLessonsTable({
    super.key,
    required this.day,
    required this.schedules,
    required this.lessonParts,
  });

  final DateTime day;
  final List<SelectedSchedule> schedules;
  final List<LessonSchedulePart> lessonParts;

  @override
  Widget build(BuildContext context) {
    final blocState = context.select((ScheduleBloc bloc) => bloc.state);

    final Map<SelectedSchedule, List<LessonSchedulePart>> lessonsPerSchedule = {
      for (var schedule in schedules)
        schedule: lessonParts
            .where(
              (lesson) => schedule.schedule.contains(lesson),
            )
            .toList()
    };

    final int maxLessons = _getMaxLessonsPerDay(schedules);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          columnWidths: {
            for (int i = 0; i < schedules.length; i++) i: const FixedColumnWidth(220),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.top,
          children: [
            TableRow(
              children: schedules
                  .map(
                    (schedule) => _ComparisonScheduleLegend(schedule: schedule),
                  )
                  .toList(),
            ),
            for (int lessonIndex = 0; lessonIndex < maxLessons; lessonIndex++)
              TableRow(
                children: schedules.map((schedule) {
                  final lesson = lessonsPerSchedule[schedule]?.firstWhereOrNull(
                    (lesson) => lesson.lessonBells.number == (lessonIndex + 1),
                  );
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: lesson != null
                        ? Container(
                            decoration: BoxDecoration(
                              color: _getBackgroundColor(blocState, schedule),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: LessonCard(
                              lesson: lesson,
                              onTap: (lesson) {
                                context.go('/schedule/details', extra: (lesson, day));
                              },
                            ),
                          )
                        : Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: _getBackgroundColor(blocState, schedule).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: EmptyLessonCard(lessonNumber: lessonIndex + 1),
                          ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor(ScheduleState state, SelectedSchedule schedule) {
    final index = state.comparisonSchedules.toList().indexOf(schedule);
    final colors = [
      AppColors.dark.colorful01.withOpacity(0.1),
      AppColors.dark.colorful02.withOpacity(0.1),
      AppColors.dark.colorful03.withOpacity(0.1),
      AppColors.dark.colorful04.withOpacity(0.1),
      AppColors.dark.colorful05.withOpacity(0.1),
      AppColors.dark.colorful06.withOpacity(0.1),
      AppColors.dark.colorful07.withOpacity(0.1),
    ];
    return colors[index % colors.length];
  }

  int _getMaxLessonsPerDay(List<SelectedSchedule> schedules) {
    int max = 0;
    for (var schedule in schedules) {
      final lessonsByDay = <DateTime, List<LessonSchedulePart>>{};
      for (final part in schedule.schedule.whereType<LessonSchedulePart>()) {
        for (final date in part.dates) {
          final day = DateTime(date.year, date.month, date.day);
          lessonsByDay.update(
            day,
            (existing) => existing..add(part),
            ifAbsent: () => [part],
          );
        }
      }
      for (var lessons in lessonsByDay.values) {
        if (lessons.length > max) max = lessons.length;
      }
    }
    return max;
  }
}

class _ComparisonScheduleLegend extends StatelessWidget {
  const _ComparisonScheduleLegend({
    required this.schedule,
  });

  final SelectedSchedule schedule;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: _getLegendColor(context),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            _getScheduleTitle(schedule),
            style: AppTextStyle.captionL,
          ),
        ],
      ),
    );
  }

  Color _getLegendColor(BuildContext context) {
    final blocState = context.read<ScheduleBloc>().state;
    final index = blocState.comparisonSchedules.toList().indexOf(schedule);
    final colors = [
      AppColors.dark.colorful01.withOpacity(0.8),
      AppColors.dark.colorful02.withOpacity(0.8),
      AppColors.dark.colorful03.withOpacity(0.8),
      AppColors.dark.colorful04.withOpacity(0.8),
      AppColors.dark.colorful05.withOpacity(0.8),
      AppColors.dark.colorful06.withOpacity(0.8),
      AppColors.dark.colorful07.withOpacity(0.8),
    ];
    return colors[index % colors.length];
  }

  String _getScheduleTitle(SelectedSchedule schedule) {
    if (schedule is SelectedGroupSchedule) {
      return schedule.group.name;
    } else if (schedule is SelectedTeacherSchedule) {
      return schedule.teacher.name;
    } else if (schedule is SelectedClassroomSchedule) {
      return schedule.classroom.name;
    }
    return 'Неизвестно';
  }
}
