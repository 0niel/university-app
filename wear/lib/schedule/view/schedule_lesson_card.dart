import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:schedule/schedule.dart';

class ScheduleLessonCard extends StatelessWidget {
  const ScheduleLessonCard({
    required this.lesson,
    required this.isAmbient,
    super.key,
  });

  final LessonSchedulePart lesson;
  final bool isAmbient;

  Color _lessonColor(BuildContext context) {
    final colors = Theme.of(context).colors;
    return switch (lesson.lessonType) {
      LessonType.laboratoryWork => colors.colorful02,
      LessonType.practice => colors.colorful03,
      LessonType.individualWork || LessonType.credit => colors.colorful07,
      LessonType.exam || LessonType.physicalEducation => colors.colorful06,
      LessonType.consultation => colors.colorful04,
      LessonType.courseWork || LessonType.courseProject => colors.colorful05,
      LessonType.lecture || LessonType.unknown => colors.colorful01,
    };
  }

  String get _lessonTypeLabel => switch (lesson.lessonType) {
    LessonType.lecture => 'ЛК',
    LessonType.practice => 'ПР',
    LessonType.laboratoryWork => 'ЛБ',
    LessonType.physicalEducation => 'ФК',
    LessonType.exam => 'ЭК',
    LessonType.credit => 'ЗЧ',
    LessonType.consultation => 'КС',
    LessonType.courseWork => 'КР',
    LessonType.courseProject => 'КП',
    LessonType.individualWork => 'СР',
    LessonType.unknown => '??',
  };

  bool get _isActiveNow {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = DateTime(
      today.year,
      today.month,
      today.day,
      lesson.lessonBells.startTime.hour,
      lesson.lessonBells.startTime.minute,
    );
    final end = DateTime(
      today.year,
      today.month,
      today.day,
      lesson.lessonBells.endTime.hour,
      lesson.lessonBells.endTime.minute,
    );
    return (now.isAtSameMomentAs(start) || now.isAfter(start)) &&
        now.isBefore(end);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    final isActive = !isAmbient;
    final color = _lessonColor(context);
    final isCurrentLesson = _isActiveNow;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          color: isActive
              ? (isCurrentLesson
                    ? color.withValues(alpha: 0.08)
                    : colors.surface)
              : colors.surfaceLow,
          borderRadius: BorderRadius.circular(16),
          border: isCurrentLesson && isActive
              ? Border.all(color: color.withValues(alpha: 0.4), width: 1.5)
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              if (isCurrentLesson && isActive)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color, color.withValues(alpha: 0.7)],
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  12,
                  isCurrentLesson && isActive ? 10 : 12,
                  12,
                  12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildLessonTypeBadge(
                          context,
                          isActive ? color : colors.deactiveDarker,
                        ),
                        const SizedBox(width: 6),
                        if (lesson.lessonBells.number case final number?)
                          _buildLessonNumberBadge(
                            context,
                            number,
                            color,
                            isActive,
                          ),
                        const Spacer(),
                        Text(
                          '${lesson.lessonBells.startTime} - '
                          '${lesson.lessonBells.endTime}',
                          style: AppText.captionSmall.copyWith(
                            color: isActive
                                ? (isCurrentLesson ? color : colors.deactive)
                                : colors.deactiveDarker,
                            fontWeight: isCurrentLesson
                                ? FontWeight.w600
                                : FontWeight.w500,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      lesson.subject,
                      style: AppText.heading.copyWith(
                        color: isActive ? colors.active : colors.deactive,
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (lesson.classrooms.isNotEmpty ||
                        lesson.teachers.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      if (lesson.classrooms case [final classroom, ...])
                        _buildLessonMetadataRow(
                          context: context,
                          icon: Icons.location_on,
                          value: classroom.name,
                          isActive: isActive,
                          textStyle: AppText.caption.copyWith(
                            color: isActive ? colors.active : colors.deactive,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      if (lesson.teachers case [final teacher, ...]) ...[
                        const SizedBox(height: 4),
                        _buildLessonMetadataRow(
                          context: context,
                          icon: Icons.person,
                          value: teacher.name,
                          isActive: isActive,
                          textStyle: AppText.captionSmall.copyWith(
                            color: colors.deactive,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLessonTypeBadge(BuildContext context, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      _lessonTypeLabel,
      style: AppText.chip.copyWith(
        color: Theme.of(context).colors.white,
        fontSize: 9,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
    ),
  );

  Widget _buildLessonNumberBadge(
    BuildContext context,
    int number,
    Color color,
    bool isActive,
  ) {
    final colors = Theme.of(context).colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: isActive ? colors.background03 : colors.surfaceLow,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isActive ? color.withValues(alpha: 0.2) : colors.borderLight,
        ),
      ),
      child: Text(
        '$number',
        style: AppText.chip.copyWith(
          color: isActive ? color : colors.deactiveDarker,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLessonMetadataRow({
    required BuildContext context,
    required IconData icon,
    required String value,
    required bool isActive,
    required TextStyle textStyle,
  }) {
    final colors = Theme.of(context).colors;
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: colors.background03.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            icon,
            size: 10,
            color: isActive ? colors.deactive : colors.deactiveDarker,
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            style: textStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
