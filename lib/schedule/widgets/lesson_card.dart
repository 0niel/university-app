import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:university_app_server_api/client.dart';

import '../schedule.dart';

class LessonCard extends StatelessWidget {
  final LessonSchedulePart lesson;

  const LessonCard({
    Key? key,
    required this.lesson,
  }) : super(key: key);

  static Color getColorByType(LessonType lessonType) {
    switch (lessonType) {
      case LessonType.lecture:
        return AppTheme.colors.colorful01;
      case LessonType.laboratoryWork:
        return AppTheme.colors.colorful02;
      case LessonType.practice:
        return AppTheme.colors.colorful03;
      case LessonType.individualWork:
        return AppTheme.colors.colorful07;
      case LessonType.exam:
        return AppTheme.colors.colorful06;
      case LessonType.credit:
        return AppTheme.colors.colorful07;
      case LessonType.consultation:
        return AppTheme.colors.colorful04;
      case LessonType.courseWork:
        return AppTheme.colors.colorful05;
      case LessonType.courseProject:
        return AppTheme.colors.colorful05;

      default:
        return AppTheme.colors.colorful01;
    }
  }

  String _getLessonTypeName(LessonType lessonType) {
    switch (lessonType) {
      case LessonType.lecture:
        return 'Лекция';
      case LessonType.laboratoryWork:
        return 'Лабораторная';
      case LessonType.practice:
        return 'Практика';
      case LessonType.individualWork:
        return 'Сам. работа';
      case LessonType.exam:
        return 'Экзамен';
      case LessonType.consultation:
        return 'Консультация';
      case LessonType.courseWork:
        return 'Курс. раб.';
      case LessonType.courseProject:
        return 'Курс. проект';
      case LessonType.credit:
        return 'Зачет';
      default:
        return 'Неизвестно';
    }
  }

  String _getClassroomNames(List<Classroom> classrooms) {
    return classrooms
        .map((e) =>
            e.name +
            (e.campus != null
                ? ' (${e.campus?.shortName ?? e.campus?.name ?? ''})'
                : ''))
        .join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<ScheduleBloc>().state;

    return Card(
      margin: const EdgeInsets.all(0),
      color: AppTheme.themeMode == ThemeMode.dark
          ? AppTheme.colors.background03
          : AppTheme.colors.background02,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      surfaceTintColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(minHeight: 75),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: getColorByType(lesson.lessonType),
                        ),
                        height: 7,
                        width: 7,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Animate(autoPlay: false).toggle(
                        duration: const Duration(milliseconds: 150),
                        builder: (_, value, __) => Text(
                          state.isMiniature
                              ? '${_getLessonTypeName(lesson.lessonType)} в ${lesson.classrooms.map((e) => e.name).join(', ')}'
                              : _getLessonTypeName(lesson.lessonType),
                          style: AppTextStyle.captionL.copyWith(
                            color: AppTheme.colors.deactive,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    lesson.subject,
                    style: AppTextStyle.titleM,
                    maxLines: 8,
                    overflow: TextOverflow.visible,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${lesson.lessonBells.number} пара',
                        style: AppTextStyle.body
                            .copyWith(color: AppTheme.colors.colorful03),
                      ),
                      Text(
                        'в ${lesson.lessonBells.startTime} - ${lesson.lessonBells.endTime}',
                        style: AppTextStyle.body.copyWith(
                          color: AppTheme.colors.colorful03,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        color: AppTheme.colors.deactive.withOpacity(0.1),
                        thickness: 1,
                        height: 30,
                      ),
                      if (lesson.classrooms.isNotEmpty) ...[
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.mapLocation,
                              size: 12,
                              color: AppTheme.colors.deactive,
                            ),
                            const SizedBox(
                              width: 6.5,
                            ),
                            Expanded(
                              child: Text(
                                _getClassroomNames(lesson.classrooms),
                                style: AppTextStyle.body
                                    .copyWith(color: AppTheme.colors.active),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (lesson.groups != null &&
                          lesson.groups!.length > 1) ...[
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.users,
                              size: 12,
                              color: AppTheme.colors.deactive,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Expanded(
                              child: Text(
                                lesson.groups?.join(', ') ?? '',
                                style: AppTextStyle.body
                                    .copyWith(color: AppTheme.colors.deactive),
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (lesson.teachers.isNotEmpty) ...[
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          lesson.teachers.map((e) => e.name).join(', '),
                          style: AppTextStyle.body
                              .copyWith(color: AppTheme.colors.deactive),
                        ),
                      ],
                    ],
                  )
                      .animate(
                    autoPlay: false,
                  )
                      .toggle(
                    builder: (_, value, child) {
                      final ch = AnimatedSize(
                        duration: const Duration(milliseconds: 150),
                        child: state.isMiniature ? const SizedBox() : child,
                      );
                      return ch;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 8,
            ),
          ],
        ),
      ),
    );
  }
}
