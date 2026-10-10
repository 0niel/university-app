import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/teacher_account/domain/teacher_workload.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_resource.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/dashboard/teacher_lesson_tile.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/dashboard/teacher_rating_shortcut.dart';
import 'package:schedule_repository/schedule_repository.dart';

class TeacherDashboardIdentitySection extends StatelessWidget {
  const TeacherDashboardIdentitySection({
    required this.teacher,
    required this.rating,
    required this.preview,
    required this.now,
    required this.navigationBusy,
    required this.onChangeTeacher,
    required this.onOpenReviews,
    required this.onRetryRating,
    required this.onOpenSchedule,
    required this.onOpenLesson,
    super.key,
  });

  final Teacher teacher;
  final TeacherResource<TeacherProfile> rating;
  final TeacherLessonOccurrence? preview;
  final DateTime now;
  final bool navigationBusy;
  final VoidCallback onChangeTeacher;
  final VoidCallback onOpenReviews;
  final VoidCallback onRetryRating;
  final VoidCallback onOpenSchedule;
  final ValueChanged<TeacherLessonOccurrence> onOpenLesson;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final compactIdentity =
        MediaQuery.sizeOf(context).width < 360 ||
        MediaQuery.textScalerOf(context).scale(1) > 1.4 ||
        teacher.name.length > 45;
    final nameStyle = teacher.name.length > 45 && compactIdentity
        ? AppText.sans(17, FontWeight.w700)
        : compactIdentity
        ? AppText.title
        : AppText.serif(28, height: 1.2);
    final name = Text(
      teacher.name.length > 45 && compactIdentity
          ? teacher.name.replaceAll('-', '-\n')
          : teacher.name,
      key: const ValueKey('teacher-dashboard-name'),
      semanticsLabel: teacher.name,
      style: nameStyle.copyWith(color: colors.ink),
    );
    final subtitle = Text(
      l10n.teacherCabinetSubtitle,
      style: AppText.body.copyWith(color: colors.muted),
    );
    final changeTeacher = AppIconButton(
      key: const ValueKey('teacher-dashboard-change-teacher'),
      tooltip: l10n.teacherChange,
      tone: AppIconButtonTone.plain,
      icon: const AppLineIconWidget(AppLineIcon.pencil),
      onPressed: onChangeTeacher,
    );
    final lesson = preview;
    final current =
        lesson != null &&
        !lesson.isCancelled &&
        !now.isBefore(lesson.start) &&
        now.isBefore(lesson.end);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.lg),
        if (teacher.name.length > 45 && compactIdentity) ...[
          name,
          const SizedBox(height: AppSpacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: subtitle),
              const SizedBox(width: AppSpacing.sm),
              changeTeacher,
            ],
          ),
        ] else ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: name),
              const SizedBox(width: AppSpacing.sm),
              changeTeacher,
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          subtitle,
        ],
        const SizedBox(height: AppSpacing.md),
        TeacherRatingShortcut(
          resource: rating,
          onTap: rating.data != null
              ? onOpenReviews
              : rating.hasError
              ? onRetryRating
              : null,
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton.primary(
          label: l10n.teacherOwnSchedule,
          expanded: true,
          loading: navigationBusy,
          onPressed: navigationBusy ? null : onOpenSchedule,
        ),
        if (lesson != null) ...[
          AppOverline(
            current ? l10n.teacherCurrentLesson : l10n.teacherNextLesson,
          ),
          TeacherLessonTile(
            occurrence: lesson,
            now: now,
            isNext: true,
            showDate: true,
            onTap: () => onOpenLesson(lesson),
          ),
        ],
      ],
    );
  }
}
