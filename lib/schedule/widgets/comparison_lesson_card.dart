import 'package:flutter/material.dart';
import 'package:university_app_server_api/client.dart';
import 'package:app_ui/app_ui.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';

class ComparisonLessonCard extends StatelessWidget {
  const ComparisonLessonCard({super.key, required this.lesson, required this.backgroundColor, this.onTap});

  final LessonSchedulePart lesson;
  final Color backgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final lessonColor = LessonCard.getColorByType(lesson.lessonType);

    return Card(
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: backgroundColor.withOpacity(0.4), width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: backgroundColor.withOpacity(0.08),
      surfaceTintColor: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subject name
              Text(
                lesson.subject,
                style: AppTextStyle.titleS.copyWith(height: 1.3, fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),

              // Time indicator (with null safety)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: lessonColor.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HugeIcon(icon: HugeIcons.strokeRoundedClock01, size: 14, color: lessonColor),
                    const SizedBox(width: 4),
                    Text(
                      '${lesson.lessonBells.startTime} - ${lesson.lessonBells.endTime}',
                      style: AppTextStyle.captionL.copyWith(color: lessonColor, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

              // Lesson type
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: lessonColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(
                  LessonCard.getLessonTypeName(lesson.lessonType),
                  style: AppTextStyle.captionL.copyWith(color: lessonColor, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 12),

              // Location info if available
              if (lesson.classrooms.isNotEmpty)
                _buildInfoRow(context, HugeIcons.strokeRoundedUniversity, _getClassroomNames(lesson.classrooms)),

              // Teacher info if available
              if (lesson.teachers.isNotEmpty)
                _buildInfoRow(context, HugeIcons.strokeRoundedTeacher, lesson.teachers.map((e) => e.name).join(', ')),

              // Groups info if available and more than one
              if (lesson.groups != null && lesson.groups!.length > 1)
                _buildInfoRow(context, HugeIcons.strokeRoundedUserGroup, lesson.groups!.join(', ')),
            ],
          ),
        ),
      ),
    );
  }

  String _getClassroomNames(List<Classroom> classrooms) {
    return classrooms
        .map((e) => e.name + (e.campus != null ? ' (${e.campus?.shortName ?? e.campus?.name ?? ''})' : ''))
        .join(', ');
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: Theme.of(context).extension<AppColors>()!.background03.withOpacity(0.7),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: HugeIcon(icon: icon, size: 12, color: Theme.of(context).extension<AppColors>()!.deactive),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                text,
                style: AppTextStyle.body.copyWith(color: Theme.of(context).extension<AppColors>()!.active, height: 1.3),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
