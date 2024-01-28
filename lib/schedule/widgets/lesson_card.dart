import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:university_app_server_api/client.dart';

import '../schedule.dart';

class LessonCard extends StatelessWidget {
  const LessonCard({
    Key? key,
    required this.lesson,
    this.onTap,
  }) : super(key: key);

  final LessonSchedulePart lesson;
  final void Function(LessonSchedulePart)? onTap;

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

  static String getLessonTypeName(LessonType lessonType) {
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
        .map((e) => e.name + (e.campus != null ? ' (${e.campus?.shortName ?? e.campus?.name ?? ''})' : ''))
        .join(', ');
  }

  Widget _buildCommentAlert(List<ScheduleComment> comments) {
    final comment = comments.firstWhereOrNull(
      (comment) => lesson.dates.contains(comment.lessonDate) && comment.lessonBells == lesson.lessonBells,
    );

    if (comment == null) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.colors.colorful01.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const FaIcon(
            FontAwesomeIcons.comment,
            size: 16,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
              comment.text,
              style: AppTextStyle.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<ScheduleBloc>().state;

    return Card(
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      surfaceTintColor: Colors.transparent,
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: InkWell(
          onTap: () {
            onTap?.call(lesson);
          },
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
                                  ? '${getLessonTypeName(lesson.lessonType)} в ${lesson.classrooms.map((e) => e.name).join(', ')}'
                                  : getLessonTypeName(lesson.lessonType),
                              style: AppTextStyle.captionL.copyWith(
                                color: AppTheme.colorsOf(context).deactive,
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
                            style: AppTextStyle.body.copyWith(color: AppTheme.colorsOf(context).colorful03),
                          ),
                          Text(
                            'в ${lesson.lessonBells.startTime} - ${lesson.lessonBells.endTime}',
                            style: AppTextStyle.body.copyWith(
                              color: AppTheme.colorsOf(context).colorful03,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(
                            color: AppTheme.colorsOf(context).deactive.withOpacity(0.1),
                            thickness: 1,
                            height: 30,
                          ),
                          if (lesson.classrooms.isNotEmpty) ...[
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: FaIcon(
                                    FontAwesomeIcons.mapLocation,
                                    size: 12,
                                    color: AppTheme.colorsOf(context).deactive,
                                  ),
                                ),
                                const SizedBox(
                                  width: 6.5,
                                ),
                                Expanded(
                                  child: Text(
                                    _getClassroomNames(lesson.classrooms),
                                    style: AppTextStyle.body.copyWith(color: AppTheme.colorsOf(context).active),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          // Dont show groups if there is only one group for
                          // SelectedGroupSchedule because this is the group
                          // that was selected.
                          if (lesson.groups != null &&
                              ((state.selectedSchedule is! SelectedGroupSchedule && lesson.groups!.isNotEmpty) ||
                                  (state.selectedSchedule is SelectedGroupSchedule && lesson.groups!.length > 1))) ...[
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: FaIcon(
                                    FontAwesomeIcons.users,
                                    size: 12,
                                    color: AppTheme.colorsOf(context).deactive,
                                  ),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Expanded(
                                  child: Text(
                                    lesson.groups?.join(', ') ?? '',
                                    style: AppTextStyle.body.copyWith(color: AppTheme.colorsOf(context).deactive),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (lesson.teachers.isNotEmpty) ...[
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 2, right: 7, top: 3),
                                  child: FaIcon(
                                    FontAwesomeIcons.userTie,
                                    size: 12,
                                    color: AppTheme.colorsOf(context).deactive,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    lesson.teachers.map((e) => e.name).join(', '),
                                    style: AppTextStyle.body.copyWith(color: AppTheme.colorsOf(context).deactive),
                                  ),
                                ),
                              ],
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
                      _buildCommentAlert(state.comments),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
