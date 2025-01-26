import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:university_app_server_api/client.dart';
import 'package:intl/intl.dart';
import '../schedule.dart';

class LessonCard extends StatelessWidget {
  const LessonCard({
    super.key,
    required this.lesson,
    this.indexInGroup,
    this.countInGroup,
    this.onTap,
  });

  final LessonSchedulePart lesson;
  final void Function(LessonSchedulePart)? onTap;
  final int? indexInGroup;
  final int? countInGroup;

  static Color getColorByType(LessonType lessonType) {
    switch (lessonType) {
      case LessonType.lecture:
        return AppColors.dark.colorful01;
      case LessonType.laboratoryWork:
        return AppColors.dark.colorful02;
      case LessonType.practice:
        return AppColors.dark.colorful03;
      case LessonType.individualWork:
        return AppColors.dark.colorful07;
      case LessonType.exam:
        return AppColors.dark.colorful06;
      case LessonType.credit:
        return AppColors.dark.colorful07;
      case LessonType.consultation:
        return AppColors.dark.colorful04;
      case LessonType.courseWork:
        return AppColors.dark.colorful05;
      case LessonType.courseProject:
        return AppColors.dark.colorful05;

      default:
        return AppColors.dark.colorful01;
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

  Widget _buildCommentAlert(BuildContext context, List<LessonComment> comments) {
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
        color: AppColors.dark.colorful01.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedComment01,
            color: Theme.of(context).extension<AppColors>()!.deactive,
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
        child: PlatformInkWell(
          borderRadius: BorderRadius.circular(12),
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
                                color: Theme.of(context).extension<AppColors>()!.deactive,
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
                            style:
                                AppTextStyle.body.copyWith(color: Theme.of(context).extension<AppColors>()!.colorful03),
                          ),
                          Text(
                            '${lesson.lessonBells.startTime} - ${lesson.lessonBells.endTime}',
                            style: AppTextStyle.body.copyWith(
                              color: Theme.of(context).extension<AppColors>()!.colorful03,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(height: 18),
                          if (lesson.classrooms.isNotEmpty) ...[
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HugeIcon(
                                  icon: HugeIcons.strokeRoundedUniversity,
                                  size: 16,
                                  color: Theme.of(context).extension<AppColors>()!.deactive,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Expanded(
                                  child: Text(
                                    _getClassroomNames(lesson.classrooms),
                                    style: AppTextStyle.body
                                        .copyWith(color: Theme.of(context).extension<AppColors>()!.active),
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
                                  child: HugeIcon(
                                    icon: HugeIcons.strokeRoundedUserGroup,
                                    size: 16,
                                    color: Theme.of(context).extension<AppColors>()!.deactive,
                                  ),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Expanded(
                                  child: Text(
                                    lesson.groups?.join(', ') ?? '',
                                    style: AppTextStyle.body
                                        .copyWith(color: Theme.of(context).extension<AppColors>()!.deactive),
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
                                  padding: const EdgeInsets.only(top: 3),
                                  child: HugeIcon(
                                    icon: HugeIcons.strokeRoundedTeacher,
                                    size: 16,
                                    color: Theme.of(context).extension<AppColors>()!.deactive,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    lesson.teachers.map((e) => e.name).join(', '),
                                    style: AppTextStyle.body
                                        .copyWith(color: Theme.of(context).extension<AppColors>()!.deactive),
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
                      _buildCommentAlert(context, state.comments),
                      _buildGroupIndicator()
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

  Widget _buildGroupIndicator() {
    if (indexInGroup == null || countInGroup == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Text(
            '$countInGroup ${Intl.plural(countInGroup!, one: 'пара', few: 'пары', many: 'пар', other: 'пар')} в это время',
            style: AppTextStyle.captionL.copyWith(
              color: AppColors.dark.colorful03,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          for (var i = 0; i < countInGroup!; i++)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                color: i == indexInGroup! ? AppColors.dark.colorful03 : AppColors.dark.colorful03.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
